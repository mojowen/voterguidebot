var InputComponent = React.createClass({
  getDefaultProps: function() {
    return {
      element: 'input',
      type: 'text',
      value: '',
      default: null,
      placeholder: null,
      className: '',
      limit: false,
      validate: false,
      fa: null,
      onChange: function() { }
    }
  },
  getInitialState: function() {
    return { is_valid: true, error_message: '' }
  },
  componentDidMount: function() {
    autosize(document.querySelectorAll('textarea'))
  },
  value: function() {
    if( !!!this.props.value ) return this.props.default || ''
    else return this.props.value || ''
  },
  isValid: function() {
    var valid = this.state.is_valid
    if( this.props.limit ) valid = valid && this.value().length <= this.props.limit
    return valid
  },
  setValid: function(is_valid, error_message) {
    this.setState({ is_valid: is_valid, error_message: error_message })
  },
  errorClass: function() {
    if( !this.state.is_valid ) return "mui--text-danger"
    var remaining = this.props.limit - this.value().length
    if( this.isValid() && remaining > 15 ) return 'mui--text-primary-hint'
    if( remaining >= 15 && remaining >= 0 ) return 'mui--text-accent-hint'
    return 'mui--text-danger'
  },
  errorMessage: function() {
    if( this.state.error_message ) return this.state.error_message
    if( this.props.limit ) return this.props.limit - (this.value()).length
  },
  does_validate: function() {
    return this.props.validate || this.props.limit
  },
  format_props: function() {
    var props = _.clone(this.props)
    if( this.props.element.match(/input|textarea/) ) {
      var allowed = ['value', 'placeholder', 'onChange', 'name', 'data-index', 'type']
      return _.pick(props, allowed)
    }
    if( this.props.validate ) props.onValidate = this.setValid
    return props
  },
  render: function() {
    var label = this.props.label ? <label>{ this.props.label }</label> : '',
        Element = to_react_class(this.props.element),
        input = <Element ref="input"
                         { ...this.format_props() }
                         onChange={this.props.onChange}
                         value={ this.value() }
                         data-valid={this.isValid()} />,
        font_awesome = '',
        className = ['mui-textfield', this.props.className],
        validation = <span ref="remaining"
                      className={'remaining '+this.errorClass()}>
                  { this.errorMessage() }
                </span>

    if( this.props.fa !== null ) {
      className.push('fa-prefix')
      font_awesome = <i className={'fa fa-'+this.props.fa} />
    }

    return <div className={className.join(' ')}>
      { label }
      { this.props.afterLabel }
      { font_awesome }
      { input }
      { this.does_validate() ? validation : '' }
      { this.props.after }
    </div>
  }
})
