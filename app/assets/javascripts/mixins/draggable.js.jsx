var Draggable = {
  getInitialState: function() {
    return { draggable: false }
  },
  draggable_props: function() {
    return { draggable: this.state.draggable,
             onDragOver: this.dragOver,
             onDragStart: this.dragStart,
             onDragEnd: this.dragEnd,
             // onTouchOver: this.dragOver,
             // onTouchStart: this.dragStart,
             // onTouchEnd: this.dragEnd,
             'data-index': this.props.index }
  },
  canDrag: function(event) {
    this.setState({ draggable: true })
  },
  cantDrag: function(event) {
    this.setState({ draggable: false })
  },
  dragStart: function(event) {
    this.constructor.prototype.draggingIndex = this.props.index

    if (event.dataTransfer !== undefined) {
      event.dataTransfer.effectAllowed = 'move'
      event.dataTransfer.setData("text/html", event.currentTarget)
    }
  },
  dragEnd: function(event) {
    this.constructor.prototype.draggingIndex = null
    this.setState({ draggable: false })
  },
  findElement: function(elem) {
    if( typeof elem.getAttribute === 'undefined' ) return false
    if( elem.getAttribute('data-index') ) return elem
    return this.findElement(elem.parentNode)
  },
  dragOver: function(event) {
    var handler = this.handleDragOver || function(current, replacement) { },
        elem = this.findElement(event.target)

    if( !!!elem ) return

    var new_index = elem.getAttribute('data-index'),
        current_index = this.constructor.prototype.draggingIndex

    if( !!!new_index ) return

    if( new_index && Number(new_index) !== current_index ) {
      handler(current_index, Number(new_index))
      this.constructor.prototype.draggingIndex = Number(new_index)
    }
  },
  draggable: function() {
    return <div onMouseDown={this.canDrag}
               onMouseUp={this.cantDrag}
               className="draggable" >
        <i className="fa fa-ellipsis-h" />
        <i className="fa fa-ellipsis-h" />
        <i className="fa fa-ellipsis-h" />
      </div>
  }
}

