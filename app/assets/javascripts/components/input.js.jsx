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
  isValid: function() {
    var val = this.props.value || ''
    return this.props.limit ? val.length <= this.props.limit : true
  },
  limitClass: function() {
    if( this.isValid() ) return 'mui--text-accent-hint'

    var remaining = this.props.limit - this.props.value.length
    if( remaining >= 15 && remaining >= 0 ) return 'mui--text-accent-secondary'
    return 'mui--text-accent mui--text-subhead'
  },
  render: function() {
    var label = this.props.label ? <label>{ this.props.label }</label> : '',
        input = <this.props.element ref="input"
                                    { ...this.props }
                                    value={ this.props.value } />,
        font_awesome = '',
        className = ['mui-textfield',this.props.className],
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
