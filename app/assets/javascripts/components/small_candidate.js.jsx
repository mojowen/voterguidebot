var SmallCandidate = React.createClass({
  render: function() {
    var photo = <img src={this.props.photo} className="profile" />,
        photo = this.props.photo ? photo : <div className="unknown profile" />

    return <div className="candidate--small">
      <span>{ this.props.name || 'Candidate Name' }</span>
      { photo }
    </div>
  }
})
