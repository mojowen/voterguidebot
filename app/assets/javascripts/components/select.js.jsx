var SelectComponent = React.createClass({
  getDefaultProps: function() {
    return {
      name: '',
      options: [],
      onChange: function() { return true },
      preview: false,
      value: null
    }
  },
  getInitialState: function() {
    return { value: this.props.value }
  },
  handleChange: function(event) {
    this.props.onChange(event)
  },
  render: function() {
    var options = _.map(this.props.options, function(option) {
      return <option key={option.value} value={option.value}>{option.text}</option>
    })

    return <div className='mui-select'>
      <select onChange={this.handleChange} value={this.props.value} >
      { options }
      </select>
    </div>
  }
})
