describe('InviteForm', function() {
  var Utils = React.addons.TestUtils
  var component, element
  
  beforeEach(function() {
    element = React.createElement(InviteForm, {})
    component = Utils.renderIntoDocument(element)
    jasmine.Ajax.install()
  })

  afterEach(function() {
    jasmine.Ajax.uninstall()
  });

  it('renders an input which accepts emails', function() {
    var dom = ReactDOM.findDOMNode(component)
    expect(dom.querySelectorAll('input[type=email]').length).toEqual(1)
  })

  it('adds emails', function() {
    spyOn(component, 'sendEmail')
    component.refs.email_input.setState({ value: 'dude@example.com' })
    Utils.Simulate.submit(component.refs.form_wrapper)

    expect(ReactDOM.findDOMNode(component).querySelectorAll('p').length).toEqual(1)
    expect(component.refs.email_input.state.value).toEqual(null)
    expect(component.sendEmail).toHaveBeenCalled()
  })

  it('does not add bad emails', function() {
    spyOn(component, 'sendEmail')
    component.refs.email_input.setState({ value: 'dude' })
    Utils.Simulate.submit(component.refs.form_wrapper)

    expect(ReactDOM.findDOMNode(component).querySelectorAll('p').length).toEqual(0)
    expect(component.refs.email_input.state.value).toEqual('dude')
    expect(component.sendEmail).not.toHaveBeenCalledWith()
  })


  it('sends ajax request', function() {
    component.sendEmail({ email: 'what@example.com', state: 'sending' })
    request = jasmine.Ajax.requests.mostRecent()
    expect(request.url).toBe('/invite')
    expect(request.method).toBe('POST')
    expect(request.data()).toEqual({
      email: 'what@example.com',
      state: 'sending'
    })
  })

  it('updates email status on success', function() {
    component.setState({ emails: [{ email: 'what@example.com', state: 'sending' }] })
    component.sendEmail(component.state.emails[0])

    request = jasmine.Ajax.requests.mostRecent()
    request.respondWith({  responseText: JSON.stringify({ state: 'success' }) })
    expect(component.state.emails[0].state).toEqual('success')
  })
})
