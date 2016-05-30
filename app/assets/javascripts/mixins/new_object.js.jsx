var NewObject = {
  newObject: function(type, props) {
    return _.defaults(props || {}, { id: _.uniqueId(type), new: true })
  }
}
