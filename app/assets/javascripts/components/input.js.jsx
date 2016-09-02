var InputComponent = React.createClass({
  getDefaultProps: function() {
    return {
      element: 'input',
      type: 'text',
      value: null,
      default: null,
      placeholder: null,
      className: '',
      limit: false,
      fa: null,
      onChange: function() { }
    }
  },
  componentDidMount: function() {
    autosize(document.querySelectorAll('textarea'))
  },
  value: function() {
    return this.props.value || this.props.default || ''
  },
  isValid: function() {
    return this.props.limit ? this.value().length <= this.props.limit : true
  },
  limitClass: function() {
    var remaining = this.props.limit - this.value().length
    if( this.isValid() && remaining > 15 ) return 'mui--text-primary-hint'
    if( remaining >= 15 && remaining >= 0 ) return 'mui--text-accent-hint'
    return 'mui--text-danger'
  },
  format_props: function() {
    if( this.props.element.match(/input|textarea/) ) {
      var allowed = ['value', 'placeholder', 'onChange', 'name', 'data-index', 'type']
      return _.pick(this.props, allowed)
    }
    return this.props
  },
  render: function() {
    var label = this.props.label ? <label>{ this.props.label }</label> : '',
        Element = to_react_class(this.props.element),
        input = <Element ref="input"
                         { ...this.format_props() }
                         value={ this.value() }
                         data-valid={this.isValid()} />,
        font_awesome = '',
        className = ['mui-textfield', this.props.className],
        limit = <span ref="remaining"
                      className={'remaining '+this.limitClass()}>
                  { this.props.limit - (this.value()).length}
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
      { this.props.limit ? limit : '' }
      { this.props.after }
    </div>
  }
})
