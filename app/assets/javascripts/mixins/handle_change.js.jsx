var HandleChange = {
  getDefaultProps: function() {
    return { changeNotifier: function() { } }
  },
  handleChange: function(key, value) {
    if( typeof key === 'object' && arguments.length === 1 ) {
      var new_state = key
    } else {
      var new_state = {}
      new_state[key] = value
    }
    this.setChangedState(new_state)
  },
  setChangedState: function(new_state) {
    this.props.changeNotifier()
    this.setState(new_state)
  }
}
