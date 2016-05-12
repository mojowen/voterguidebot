var InputComponent = React.createClass({
  getDefaultProps: function() {
    return {
      type: 'text',
      value: null,
      placeholder: null
    }
  },
  getInitialState: function() {
    return { value: this.props.value }
  },
  handleChange: function(event) {
    this.setState({ value: event.target.value })
  },
  render: function() {
    var label = this.props.label ? <label>{ this.props.label }</label> : ''
    return <div className="mui-textfield">
      { label }
      <input onChange={this.handleChange} {...this.props} value={this.state.value} />
      { this.props.after }
    </div>
  }
})
