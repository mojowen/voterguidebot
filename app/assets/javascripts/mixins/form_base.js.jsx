var FormBase = {
  getInitialState: function() {
    return { icon: 'fa-save', method: 'patch' }
  },
  getDefaultProps: function() {
    return { languages: [] }
  },
  handleError: function(res, message) {
    this.setState({ icon: 'fa-exclamation-triangle' })
    this.notify(message || 'Something went wrong saving')
  },
  handleSuccess: function(res, message) {
    this.setState({ icon: 'fa-check-square' })
    this.notify(message || 'Success!')
    if( res && res.body && res.body.path ) {
      history.pushState({}, '', res.body.path)
    }
  },
  notify: function(message) { swal(message) },
  updateGuide: function(url, data, callback) {
    this.setState({ icon: 'fa-circle-o-notch fa-spin' })

    var that = this,
        method = superagent[this.state.method],
        callback = callback || function() {}

    method(this.props.url)
      .send(data)
      .set('X-CSRF-Token', CSRF.token())
      .set('Accept', 'application/json')
      .end(function(err, res) {
          if( err ) return that.handleError(res.body)
          that.handleSuccess(res.body)
          callback(res)
        })
  },
  languageChange: function(event) {
    var search = document.location.search.split('&'),
        new_search = []

    for (var i = 0; i < search.length; i++) {
      if( search[i].search('locale') === -1 && ['','?'].indexOf(search[i]) === -1 ) {
        new_search.push(search[i])
      }
    }
    new_search.push(['locale',event.target.value].join('='))
    Turbolinks.visit([document.path, new_search.join('&')].join('?'))
  },
  menuComponent: function(before, after) {
    var languages = ''

    if( this.props.languages.length > 0 ) {
      var selected = document.location.search.match(/locale\=[A-z^&]./g)

      if( selected ) selected = selected[0].split('=')[1]

      languages = _.map(this.props.languages, function(el) {
        return <option key={el.code} value={el.code} >
                {el.name}</option>
      })
      languages = <div className="mui-select">
        <strong>Language</strong>
        <select onChange={this.languageChange} value={selected} >
        <option value="en">English</option>
        { languages }
        </select>
      </div>
    }

    return <div className="fixed--menu mui-panel">
      { before }
      { languages }
      <button type="submit" className="mui-btn mui-btn--accent">
        <i className={'fa ' + this.state.icon} /> Save
      </button>
      { after }
    </div>
  }
}

