var ContestRow = React.createClass({
  mixins: [Draggable],
  getDefaultProps: function() {
    return { id: null,
             title: '',
             description: '',
             contests: [],
             candidates: [],
             handleDrag: function() { },
             handleRemove: function() { } }
  },
  getInitialState: function() {
    return { contests: this.props.contests }
  },
  handleDragOver: function(current_index, replaced_index) {
    var contests = this.props.contests,
        current = contests[current_index],
        replaced = contests[replaced_index]

    contests[replaced_index] = current
    contests[current_index] = replaced

    this.props.handleDrag(contests)
  },
  handleRemove: function(event) {
    event.preventDefault()
    this.props.handleRemove(this.props.id)
  },
  render: function() {
    var candidates = _.map(this.props.candidates, function(cand) {
      return <SmallCandidate {...cand} key={cand.id} />
    })
    return <div className="mui-panel contest--row"
                key={this.props.id}
                {...this.draggable_props()}
                data-index={this.props.index}>
      { this.draggable() }
      <i className="fa fa-times remove" onClick={ this.handleRemove } />
      <a href={[this.props.url,this.props.id, 'edit'].join('/')}
         className="edit mui-btn mui-btn--small mui-btn--primary" >
        <i className="fa fa-pencil" />&nbsp;Edit
      </a>
      <h2>{ this.props.title }</h2>
      <div className="mui-col-sm-6">
        <p><strong>Description</strong>: { this.props.description }</p>
      </div>
      <div className="mui-col-sm-6">
        <strong>Candidates</strong>:<br/>
        { candidates }
      </div>
    </div>
  }
})
