var Candidates = React.createClass({
  mixins: [Template, NewObject],
  getDefaultProps: function() {
    return { candidates: [],
             handleChange: function() { } }
  },
  newCandidate: function() {
    return this.newObject('candidate', { endorsements: [] })
  },
  handleAdd: function(event) {
    var candidates = this.props.candidates
    candidates.push(this.newCandidate())
    this.props.handleChange('candidates', candidates)
    event.preventDefault()
  },
  render: function() {
    var candidates = _.map(this.props.candidates, function(candidate, index) {
          return <Candidate {...candidate}
                            candidates={this.props.candidates}
                            template={this.props.template}
                            key={candidate.id}
                            index={index}
                            handleChange={this.props.handleChange} />
        }, this),
      max_key = 'candidates.max'+(this.props.contest_layout === 'contest_small' ? '_small' : '')
      add_display = this.props.candidates.length >= this.template(max_key) ? 'none' : 'block'

    return <div>
      <div className="mui-row"><h3>Candidates</h3></div>
      <div className="mui-row">{ candidates }</div>
      <div className="mui-row">
        <div className="mui--pull-right">
          <a onClick={ this.handleAdd }
              style={{ display: add_display }}
              className="mui-btn mui-btn--accent">
            <i className="fa fa-plus-circle" /> Add Candidate
          </a>
        </div>
      </div>
    </div>
  }
})
