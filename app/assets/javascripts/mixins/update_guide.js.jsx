var UpdateGuide = {
  updateGuide: function(url, guide_data, callback) {
    superagent
      .patch(this.props.url)
      .send({ guide: guide_data })
      .set('X-CSRF-Token', CSRF.token())
      .set('Accept', 'application/json')
      .end(callback)
  }
}

