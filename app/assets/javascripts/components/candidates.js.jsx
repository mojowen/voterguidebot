var Candidates = React.createClass({
  mixins: [Template],
  getDefaultProps: function() {
    return { candidates: [],
             handleAdd: function() { },
             handleChange: function() { },
             handleRemove: function() { } }
  },
  render: function() {
    var candidates = _.map(this.props.candidates, function(candidate) {
          return <Candidate {...candidate}
                            template={this.props.template}
                            key={candidate.id}
                            handleChange={this.props.handleChange}
                            handleRemove={this.props.handleRemove}  />
        }, this)

    return <div>
      <div className="mui-row"><h3>Candidates</h3></div>
      <div className="mui-row">{ candidates }</div>
      <div className="mui-row">
        <div className="mui--pull-right">
          <a onClick={ this.props.handleAdd }
              className="mui-btn mui-btn--accent">
            <i className="fa fa-plus-circle" /> Add Candidate
          </a>
        </div>
      </div>
    </div>
  }
})
