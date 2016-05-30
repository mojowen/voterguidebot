var GuideForm = {
  getInitialState: function() {
    return { icon: 'fa-save' }
  },
  handleError: function(message) {
    this.setState({ icon: 'fa-exclamation-triangle' })
    this.notify(message)
  },
  handleSuccess: function(message) {
    this.setState({ icon: 'fa-check-square' })
    this.notify(message)
  },
  notify: function(message) { alert(message) },
  updateGuide: function(url, guide_data, callback) {
    this.setState({ icon: 'fa-circle-o-notch fa-spin' })

    var that = this

    superagent
      .patch(this.props.url)
      .send({ guide: guide_data })
      .set('X-CSRF-Token', CSRF.token())
      .set('Accept', 'application/json')
      .end(callback || function(err, res) {
          if( err ) that.handleError('Something went wrong saving')
          else that.handleSuccess('success')
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

