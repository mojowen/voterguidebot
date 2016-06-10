var FieldFormRow = React.createClass({
  getDefaultProps: function() {
    return { example_elem: 'p',
             example_attr: false,
             limit: false }
  },
  getInitialState: function() {
    return { value: this.props.value || '' }
  },
  getPreviewText: function() {
    return (this.state.value && this.state.value.length > 0 ? this.state.value :
                                                              this.props.example)
  },
  updateValue: function(event) {
    this.setState({ value: event.target.value })
    return true
  },
  isValid: function() {
    return this.props.limit ? this.state.value.length <= this.props.limit : true
  },
  afterClass: function() {
    if( this.isValid() ) return 'mui--text-accent'

    var remaining = this.props.limit - this.state.value.length
    if( remaining >= 15 ) return 'mui--text-dark-hint'
    else if( remaining < 15 && remaining >= 5 ) return 'mui--text-dark-secondary'
    else if( remaining < 5 && remaining >= 0 ) return 'mui--text-dark'
  },
  render: function() {
    if( this.props.example_attr ) {
      var example_props = this.props.example_props
      example_props[this.props.example_attr] = this.getPreviewText()
      var preview = <this.props.example_elem {...example_props}
                                             ref="preview"/>
    } else {
      var preview = <this.props.example_elem {...this.props.example_props}
                                             ref="preview">
        { this.getPreviewText() }
      </this.props.example_elem>
    }

    var after = <span ref="remaining"
                      className={'remaining '+this.afterClass()}>
                  { this.props.limit - this.state.value.length}
                </span>

    return <div className='mui-row form--row' >
      <div className='mui-col-md-6'>
        <InputComponent after={this.props.limit ? after : ''}
                        ref="input"
                        onChange={this.updateValue}
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
