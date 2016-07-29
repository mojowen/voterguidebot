var InputComponent = React.createClass({
  getDefaultProps: function() {
    return {
      element: 'input',
      type: 'text',
      value: null,
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
  isValid: function() {
    var val = this.props.value || ''
    return this.props.limit ? val.length <= this.props.limit : true
  },
  limitClass: function() {
    var val = this.props.value || ''

    var remaining = this.props.limit - val.length
    if( this.isValid() && remaining > 15 ) return 'mui--text-primary-hint'
    if( remaining >= 15 && remaining >= 0 ) return 'mui--text-accent-hint'
    return 'mui--text-danger'
  },
  render: function() {
    var label = this.props.label ? <label>{ this.props.label }</label> : '',
        input = <this.props.element ref="input"
                                    { ...this.props }
                                    value={ this.props.value }
                                    data-valid={this.isValid()} />,
        font_awesome = '',
        className = ['mui-textfield', this.props.className],
        limit = <span ref="remaining"
                      className={'remaining '+this.limitClass()}>
                  { this.props.limit - (this.props.value || '').length}
                </span>

    if( this.props.fa !== null ) {
      className.push('fa-prefix')
      font_awesome = <i className={'fa fa-'+this.props.fa} />
    }
    if( this.props.element === 'ImageComponent' ) {
        input = <ImageComponent ref="input"
                                { ...this.props }
                                value={ this.props.value } />
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
