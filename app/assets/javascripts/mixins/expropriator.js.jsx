var Expropriator = {
  getDefaultProps: function() {
    return { expropriatable: false }
  },
  expropriatorChange: function(event) {
    if( !event.target.value ) return
    this.refs.expropriator.action = this.props.expropriatable.path.replace(/\d+/, event.target.value)
    this.refs.expropriator.submit()
  },
  expropriator: function(id) {
    if( !this.props.expropriatable ) return ''

    var options = _.map(this.props.expropriatable.guides, function(guide) {
      return <option value={guide.id} key={guide.id}>{guide.name}</option>
    })

    disabled = typeof this.state.changed !== 'undefined' ? this.state.changed : false
    var classList = [
      disabled ? 'disabled' : null,
      "mui-select",
      "mui-btn",
      "mui-btn--danger",
      "expropriator"
    ]

    return <form method="POST"
                 ref="expropriator"
                 className={classList.join(' ')}>
      <i className="fa fa-clone" />
      <select onChange={this.expropriatorChange}>
        <option>CLONE TO GUIDE</option>
        { options }
      </select>
      <input type="hidden" name="expropriator_id" value={id || ''} />
      <input type="hidden" name="authenticity_token" value={CSRF.token()} />
    </form>
  }
}

