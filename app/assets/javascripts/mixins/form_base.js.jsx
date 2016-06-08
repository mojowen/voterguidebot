var FormBase = {
  getInitialState: function() {
    return { icon: 'fa-save', method: 'patch' }
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
  notify: function(message) { alert(message) },
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
  menuComponent: function(before, after) {
    return <div className="fixed--menu">
      { before }
      <button type="submit" className="mui-btn mui-btn--accent">
        <i className={'fa ' + this.state.icon} /> Save
      </button>
      { after }
    </div>
  }
}

