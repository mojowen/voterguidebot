var ContestsForm = React.createClass({
  mixins: [FormBase],
  getDefaultProps: function() {
    return { contests: [], draggable: true }
  },
  getInitialState: function() {
    return { contests: this.props.contests }
  },
  handleDrag: function(contests) {
    this.debounceUpdatePosition = this.debounceUpdatePosition || _.debounce(this.updatePosition, 500)
    this.debounceUpdatePosition(contests, this.state.contests)
    this.setState({ contests: contests })
  },
  updatePosition: function(new_contests, old_contests) {
    var that = this,
        url = [this.props.url, 'position'].join('/')+'.json',
        data = { contests: _.map(new_contests, 'id') }

    this.request(url, data, 'put')
        .end(function(err, res) {
          if( !err ) return
          that.handleError('Could not re-position contests')
          this.setState({ contests: old_contests })
        })
  },
  handleRemove: function(id) {
    var url = [this.props.url, id].join('/')+'.json'

    vgConfirm('Are you sure you want to remove this contest?', function(confirmed) {
      if( !confirmed ) return

      var that = this,
          contests = this.state.contests,
          removable = _.find(contests, { id: id })

      this.request(url, null, 'del')
          .end(function(err, res) {
            if( err ) return that.handleError(res.body)
            that.setState({ contests: _.without(contests, removable) })
          })
    }, this)
  },
  render: function() {
    var contests = _.map(this.state.contests, function(cont, index) {
      return <ContestRow {...cont}
                         index={index}
                         key={cont.id}
                         handleDrag={this.handleDrag}
                         handleRemove={this.handleRemove}
                         url={this.props.url}
                         draggable={this.props.draggable}
                         expropriatable={this.props.expropriatable}
                         contests={this.state.contests} />
    }, this)

    return <div className="contests--form">
      { contests }
    </div>
  }
})
