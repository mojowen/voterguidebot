describe('InviteForm', function() {

  beforeEach(function() {
    this.setUpComponent(InviteForm, { url: '/invite' })
    jasmine.Ajax.install()
  })

  afterEach(function() {
    jasmine.Ajax.uninstall()
  });

  it('renders an input which accepts emails', function() {
    expect(this.dom.querySelectorAll('input[type=email]').length).toEqual(1)
  })

  it('adds emails', function() {
    spyOn(this.component, 'sendEmail')
    this.component.refs.email_input.setState({ value: 'dude@example.com' })
    Utils.Simulate.submit(this.component.refs.form_wrapper)

    expect(ReactDOM.findDOMNode(this.component).querySelectorAll('p').length).toEqual(1)
    expect(this.component.refs.email_input.state.value).toEqual(null)
    expect(this.component.sendEmail).toHaveBeenCalled()
  })

  it('does not add bad emails', function() {
    spyOn(this.component, 'sendEmail')
    this.component.handleChange({ currentTarget: { value: 'dude' }})

    Utils.Simulate.submit(this.component.refs.form_wrapper)

    expect(ReactDOM.findDOMNode(this.component).querySelectorAll('p').length).toEqual(0)
    expect(this.component.state.email).toEqual('dude')
    expect(this.component.sendEmail).not.toHaveBeenCalledWith()
  })


  it('sends ajax request', function() {
    this.component.sendEmail({ email: 'what@example.com', state: 'sending' })
    request = jasmine.Ajax.requests.mostRecent()
    expect(request.url).toBe('/invite')
    expect(request.method).toBe('PATCH')
    expect(request.data()).toEqual({
      email: 'what@example.com',
      state: 'sending'
    })
  })

  it('updates email status on success', function() {
    this.component.setState({ emails: [{ email: 'what@example.com', state: 'sending' }] })
    this.component.sendEmail(this.component.state.emails[0])

    request = jasmine.Ajax.requests.mostRecent()
    request.respondWith({
      status: 200,
      responseText: JSON.stringify({ state: 'success' })
    })
    expect(this.component.state.emails[0].state).toEqual('success')
  })
})
