var MeasureRow = React.createClass({
  mixins: [Draggable],
  getDefaultProps: function() {
    return { id: null,
             title: '',
             description: '',
             measures: [],
             yes_means: '',
             no_means: '',
             handleDrag: function() { },
             handleRemove: function() { } }
  },
  getInitialState: function() {
    return { measures: this.props.measures }
  },
  handleDragOver: function(current_index, replaced_index) {
    var measures = this.props.measures,
        current = measures[current_index],
        replaced = measures[replaced_index]

    measures[replaced_index] = current
    measures[current_index] = replaced

    this.props.handleDrag(measures)
  },
  handleRemove: function(event) {
    event.preventDefault()
    this.props.handleRemove(this.props.id)
  },
  recommends: function(stance) {
    if( this.props.stance === stance ) return <p>
      <i className="fa fa-check-square-o" />
      &nbsp;
      <em>Recommended</em>
    </p>
  },
  render: function() {
    var stance = ''
    return <div className="mui-panel measure--row"
                key={this.props.id}
                {...this.draggable_props()}
                data-index={this.props.index}>
      { this.draggable() }
      <i className="fa fa-times remove" onClick={ this.handleRemove } />
      <a href={[this.props.url,this.props.id, 'edit'].join('/')}
         className="edit mui-btn mui-btn--small mui-btn--primary" >
        <i className="fa fa-pencil" />&nbsp;Edit
      </a>
      <div className="mui-col-sm-12">
        <h2>{ this.props.title }</h2>
        <p><strong>Description</strong>: { this.props.description }</p>
      </div>
      <div className="mui-col-sm-6 for--block">
        <p><strong>Yes</strong>: { this.props.yes_means }</p>
        { this.recommends('for') }
      </div>
      <div className="mui-col-sm-6 against--block">
        <p><strong>No</strong>: { this.props.no_means }</p>
        { this.recommends('against') }
      </div>
    </div>
  }
})
