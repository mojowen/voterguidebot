var FieldFormRow = React.createClass({
  getDefaultProps: function() {
    return { example_elem: 'p',
             example_attr: false,
             limit: false }
  },
  getInitialState: function() {
    return { value: this.props.value || '' }
  },
  getPreview: function() {
    if(!!this.state.value && this.state.value.length ) return this.state.value
    return this.props.example || this.props.default
  },
  isValid: function() {
    return this.refs.input.isValid()
  },
  updateValue: function(event) {
    this.setState({ value: event.target.value })
    return true
  },
  render: function() {
    if( this.props.example_attr ) {
      var example_props = this.props.example_props || {},
          ExampleElem = to_react_class(this.props.example_elem)
      example_props[this.props.example_attr] = this.getPreview()
      var preview = <ExampleElem {...example_props} ref="preview"/>
    } else {
      var preview = <this.props.example_elem {...this.props.example_props}
                                             ref="preview">
        { this.getPreview() }
      </this.props.example_elem>
    }

    return <div className='mui-row form--row' >
      <div className='mui-col-md-6'>
        <InputComponent limit={this.props.limit}
                        ref="input"
                        onChange={this.updateValue}
                        preview={true}
                        {...this.props}
                        value={this.state.value} />
      </div>
      <div className='mui-col-md-5 md-offset-1 mui-textfield preview--field'>
        <label>Preview:</label>
        { preview }
      </div>
    </div>
  }
})
