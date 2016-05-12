var InviteForm = React.createClass({
  getInitialState: function() {
    return { emails: [] }
  },
  handleSubmit: function(event) {
    var email = this.refs.email_input.state.value,
        emails = this.state.emails

    if( event.target.checkValidity() ) {
      var email_obj = { state: 'sending', email: email }
      emails.push(email_obj)
      this.sendEmail(email_obj)
      this.setState({ emails: emails })
      this.refs.email_input.setState({ value: null })
    }
    event.preventDefault()
  },
  sendEmail: function(email_obj) {
    var that = this

    superagent
      .post('/invite')
      .send(email_obj)
      .set('Accept', 'application/json')
      .end(function(err, res) {
        var emails = that.state.emails,
            index = emails.map(function(el) { return el.email }).indexOf(email_obj.email)

        emails[index].state = res.body.state
        that.setState({emails: emails})
      })
  },
  render: function() {
    var email_props = { type: 'email', placeholder: "Add Email" }
        email_inputs = this.state.emails.map(function(email) { 
          var state_class = (email.state === 'sending' ? 'fa-circle-o-notch fa-spin' : 'check-circle-o')
          return <p key={email}>{email.email}<i className={'fa fa-pull-right '+state_class}></i></p>}),
        button = <button style={{ marginTop: '-40px', float: 'right'}}
                         className="mui-btn mui-btn--small mui-btn--accent">+</button>

    return <form ref="form_wrapper" onSubmit={this.handleSubmit} >
      { email_inputs }
      <InputComponent ref="email_input" after={button} {...email_props} />
    </form>
  }
})
