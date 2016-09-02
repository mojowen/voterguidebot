var FormBase = {
  getInitialState: function() {
    return { loading: false,
             changed: false,
             errored: false,
             autosave: true,
             method: 'patch',
             url: this.props.url || document.location.pathname }
  },
  getDefaultProps: function() {
    return { languages: [] }
  },
  setNewObjectState: function() {
    this.setState({ method: 'post', changed: true, autosave: false })
  },
  handleError: function(body) {
    this.setState({ loading: false, errored: true, autosave: false })
    this.notify(body.error || 'Something went wrong saving')
  },
  debounceDelay: 2500,
  changeNotifer: function() {
    this.setState({ changed: true })
    if( !this.state.autosave ) return
    if( typeof this.saveGuide === 'undefined' ) return


    this.debounceSaveGuide = this.debounceSaveGuide || _.debounce(this.saveGuide, this.debounceDelay)
    this.debounceSaveGuide()
  },
  handleSuccess: function(res, message) {
    if( !this.state.autosave ) this.notify(message || 'Success!')
    this.setState({ autosave: true, loading: false, changed: false, method: 'patch' })

    if( res && res.path ) history.pushState({}, '', res.path)
    if( res && res.url ) this.setState({ url: res.url })
  },
  notify: function(message, is_error) {
    if( is_error ) return swal({ title: 'Uh Oh!', text: message })
    swal({ title: message, timer: 500 })
  },
  request: function(url, data, method) {
    var method = superagent[method || this.state.method]

    return method(url).send(data)
                      .set('X-CSRF-Token', CSRF.token())
                      .set('Accept', 'application/json')
  },
  updateGuide: function(url, data, callback) {
    if( this.state.loading ) return

    this.setState({ loading: true, errored: false })

    var that = this,
        callback = callback || function() {}
    this.request(url, data)
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
  preview_guide_url: function() {
    var guide_base = document.location.pathname.match(/\/guides\/\d+\//),
        anchor = typeof this.anchor !== 'undefined' ? this.anchor() : ''
    return guide_base + 'preview' + anchor
  },
  saveIcon: function() {
    if( this.state.loading ) return 'fa-save fa-pulse'
    if( this.state.errored ) return 'fa-exclamation-triangle'
    if( this.state.changed ) return 'fa-save'
    return 'fa-check-square'
  },
  saveText: function() {
    if( this.state.loading ) return 'Saving...'
    if( this.state.errored ) return 'Try Again'
    if( this.state.changed ) return 'Save'
    return 'Saved'
  },
  menuComponent: function(options) {
    var languages = '',
        options = options || {}

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
      { languages }
      <button type="submit" className="mui-btn mui-btn--accent"
              disabled={!this.state.changed}
              onClick={this.handleSubmit} >
        <i className={'fa ' + this.saveIcon()} />&nbsp;{ this.saveText() }
      </button>
      <button className="preview mui-btn mui-btn--primary"
               disabled={this.state.changed || this.state.errored || this.state.loading } >
        <a href={ this.preview_guide_url() } target="_blank">
          <i className="fa-newspaper-o fa" />
          &nbsp;
          Preview
        </a>
      </button>
      { options.after }
    </div>
  }
}

