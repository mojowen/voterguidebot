var HandleChange = {
  getInitialState: function() {
    return { changed: false }
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
    new_state.changed = true
    this.setState(new_state)
  }
}
