var FieldFormRow = React.createClass({
  mixins: [HandleChange],
  getDefaultProps: function() {
    return { example_elem: 'p',
             example_attr: false,
             limit: false }
  },
  getInitialState: function() {
    return { value: this.props.value }
  },
  getPreview: function() {
    var value = this.state.value
    if( !!!value && (value || '').length < 1 ) value = this.props.example || this.props.default
    if( this.props.clear_brackets ) value = value.replace(/\{.*\}/, this.props.clear_brackets)
    return value
  },
  isValid: function() {
    return this.refs.input.isValid()
  },
  updateValue: function(event) {
    this.setChangedState({ value: event.target.value })
  },
  render: function() {
    var example_props = this.props.example_props || {},
        ExampleElem = to_react_class(this.props.example_elem)

    example_props[this.props.example_attr] = this.getPreview()
    delete example_props['false']

    if( ExampleElem === 'img' ) {
      var preview = <ExampleElem {...example_props} ref="preview" />
    } else {
      var preview = <ExampleElem {...example_props} ref="preview">
        { this.getPreview() }
      </ExampleElem>
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
