var InputComponent = React.createClass({
  getDefaultProps: function() {
    return {
      element: 'input',
      type: 'text',
      value: null,
      placeholder: null,
      onChangeCallback: function() { return true }
    }
  },
  getInitialState: function() {
    return { value: this.props.value }
  },
  handleChange: function(event) {
    var value = event.target.value
    if( this.props.onChangeCallback(value) ) this.setState({ value: value })
  },
  render: function() {
    var label = this.props.label ? <label>{ this.props.label }</label> : '',
        input = <this.props.element ref="input"
                                    onChange={ this.handleChange }
                                    { ...this.props }
                                    value={ this.state.value } />
    if( this.props.element === 'ImageComponent' ) {
        input = <ImageComponent ref="input"
                                onChange={ this.handleChange }
                                { ...this.props }
                                value={ this.state.value } />
    }

    return <div className="mui-textfield">
      { label }
      { this.props.afterLabel }
      { input }
      { this.props.after }
    </div>
  }
})
