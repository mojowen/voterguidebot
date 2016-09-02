var InviteForm = React.createClass({
  mixins: [FormBase],
  getInitialState: function() {
    return { emails: [], email: '' }
  },
  handleSubmit: function(event) {
    var emails = this.state.emails

    if( event.target.checkValidity() && this.state.email.length > 0 ) {
      var email_obj = { state: 'sending', email: this.state.email }
      emails.push(email_obj)
      this.sendEmail(email_obj)
      this.setState({ emails: emails, email: '' })
      this.refs.email_input.setState({ value: null })
    }
    event.preventDefault()
  },
  handleChange: function(event) {
    this.setState({ email: event.currentTarget.value })
  },
  sendEmail: function(email_obj) {
    var that = this

    this.updateGuide(this.props.url, email_obj, function(res) {
      var emails = that.state.emails,
          index = emails.map(function(el) { return el.email })
                        .indexOf(email_obj.email)

      emails[index].state = res.body.state
      that.setState({emails: emails})
    })
  },
  render: function() {
    var email_props = { type: 'email', placeholder: "Add Email", value: this.state.email }
        email_inputs = this.state.emails.map(function(email) {
          var state_class = (email.state === 'sending' ? 'fa-circle-o-notch fa-spin' : 'fa-check-circle-o')
          return <p key={email}>{email.email}<i className={'fa fa-pull-right '+state_class}></i></p>}),
        button = <button style={{ marginTop: '-40px', float: 'right'}}
                         className="mui-btn mui-btn--small mui-btn--accent">+</button>

    return <form ref="form_wrapper" onSubmit={this.handleSubmit} >
      { email_inputs }
      <InputComponent onChange={this.handleChange} ref="email_input" after={button} {...email_props} />
    </form>
  }
})
