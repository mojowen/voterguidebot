var MeasuresForm = React.createClass({
  mixins: [FormBase],
  getDefaultProps: function() {
    return { measures: [] }
  },
  getInitialState: function() {
    return { measures: this.props.measures }
  },
  handleDrag: function(measures) {
    this.debounceUpdatePosition = this.debounceUpdatePosition || _.debounce(this.updatePosition, 500)
    this.debounceUpdatePosition(measures, this.state.measures)
    this.setState({ measures: measures })
  },
  updatePosition: function(new_measures, old_measures) {
    var that = this,
        url = [this.props.url, 'position'].join('/')+'.json',
        data = { measures: _.map(new_measures, 'id') }

    this.request(url, data, 'put')
        .end(function(err, res) {
          if( !err ) return
          that.handleError('Could not re-position measures')
          this.setState({ measures: old_measures })
        })
  },
  handleRemove: function(id) {
    var url = [this.props.url, id].join('/')+'.json'

    vgConfirm('Are you sure you want to remove this measure?', function(confirmed) {
      if( !confirmed ) return

      var that = this,
          measures = this.state.measures,
          removable = _.find(measures, { id: id })

      this.request(url, null, 'del')
          .end(function(err, res) {
            if( err ) return that.handleError(res.body)
            that.setState({ measures: _.without(measures, removable) })
          })
    }, this)
  },
  render: function() {
    var measures = _.map(this.state.measures, function(measure, index) {
      return <MeasureRow {...measure}
                         index={index}
                         key={measure.id}
                         handleDrag={this.handleDrag}
                         handleRemove={this.handleRemove}
                         url={this.props.url}
                         measures={this.state.measures} />
    }, this)

    return <div className="measures--form">
      { measures }
    </div>
  }
})
