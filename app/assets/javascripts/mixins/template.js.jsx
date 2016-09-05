var Template = {
  template: function(keys, fallback) {
    var keys = keys.split('.'),
        object = this.props

    keys.unshift('template')

    for (var i = 0; i < keys.length; i++) {
      if( typeof object[keys[i]] !== 'undefined') object = object[keys[i]]
      else return fallback
    }
    return object
  },
}
