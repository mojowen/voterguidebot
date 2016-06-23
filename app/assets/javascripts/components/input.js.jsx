var InputComponent = React.createClass({
  getDefaultProps: function() {
    return {
      element: 'input',
      type: 'text',
      value: null,
      placeholder: null,
      className: '',
      fa: null,
      onChange: function() { }
    }
  },
  handleChange: function(event) {
    this.props.handleChange(event)
  },
  render: function() {
    var label = this.props.label ? <label>{ this.props.label }</label> : '',
        input = <this.props.element ref="input"
                                    { ...this.props }
                                    value={ this.props.value } />,
        font_awesome = '',
        className = ['mui-textfield',this.props.className]

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
      { this.props.after }
    </div>
  }
})
