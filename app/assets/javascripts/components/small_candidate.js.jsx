var SmallCandidate = React.createClass({
  render: function() {
    var photo = <div style={{ backgroundImage: "url("+this.props.photo+")" }}
                     className="img profile"></div>,
        photo = this.props.photo ? photo : <div className="unknown profile" />

    return <div className="candidate--small">
      <span>{ this.props.name || 'Candidate Name' }</span>
      { photo }
    </div>
  }
})
