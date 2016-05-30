var ContestsForm = React.createClass({
  mixins: [GuideForm, NewObject],
  getDefaultProps: function() {
    return { contests: [] }
  },
  componentDidMount: function() {
    if( this.state.contests.length === 0 ) {
      this.setState({ contests: [this.newObject('contest')] })
    }
  },
  getInitialState: function() {
    return { contests: this.props.contests }
  },
  handleSubmit: function(event) {
    var contests_request = {}

    this.updateGuide(this.props.url, { contests: contests_request })
    event.preventDefault()
  },
  handleClickToAddContest: function(event) {
    var contests = this.state.contests
    contests.push(this.newObject('contest'))
    this.setState({ contests: contests })
    event.preventDefault()
  },
  render: function() {
    var contests = _.map(this.state.contests, function(contest) {
      return <Contest ref={contest.id}
                      key={contest.id}
                      {...contest} /> }),
        addContest = <div><a onClick={ this.handleClickToAddContest }
                        className="mui-btn mui-btn--accent">
                      <i className="fa fa-plus-circle" /> Add Contest
                    </a><br /></div>

    return <form autoComplete="off" ref="form_wrapper" onSubmit={this.handleSubmit}>
            { contests }
            { this.menuComponent(addContest) }
          </form>
  }
})
