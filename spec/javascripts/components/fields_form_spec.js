describe('FieldsForm', function() {

  beforeEach(function() {
    this.fields = [
      { name: (new Date())+' Field',
        element: 'input',
        example: '2016 [Your state / region] Voter Guide',
        limit: 40,
        name: 'great_input' },
      { name: 'Great Field',
        element: 'textarea',
        example: 'Really long example',
        limit: 349,
        value: 'someone wrote something',
        name: 'great_textarea' }
    ]
    this.url = '/guide/1'
    this.setUpComponent(FieldsForm, { fields: this.fields, url: this.url })
    jasmine.Ajax.install()
  })

  afterEach(function() {
    jasmine.Ajax.uninstall()
  });

  it('creates rows for the fields', function() {
    expect(this.dom.querySelectorAll('.mui-row').length).toEqual(2)
  })

  it('assigns values to rows', function() {
    expect(this.dom.querySelector('textarea').value).toEqual(this.fields[1].value)
    expect(this.component.refs.great_textarea.state.value).toEqual(this.fields[1].value)
  })

  it('submit updates guide', function() {
    spyOn(this.component, 'updateGuide')
    this.component.refs.great_input.setState({ value: 'whatt' })
    Utils.Simulate.submit(this.component.refs.form_wrapper)
    expect(this.component.updateGuide).toHaveBeenCalledWith(
      this.url,
      { guide: { fields: { great_input: 'whatt', great_textarea: 'someone wrote something'}}})
  })

  it('sends ajax request', function() {
    this.component.updateGuide(this.url, { guide: { fields: { great_input: 'whatt' }}})
    request = jasmine.Ajax.requests.mostRecent()
    expect(request.url).toBe(this.url)
    expect(request.method).toBe('PATCH')
    expect(request.data()).toEqual({ guide: { fields: { great_input: 'whatt' }}})
  })

  it('notifies on a success', function() {
    spyOn(this.component, 'notify')
    this.component.updateGuide(this.url, {})
    request = jasmine.Ajax.requests.mostRecent()
    request.respondWith({  responseText: '', status: 200 })
    expect(this.component.notify).toHaveBeenCalledWith('Success!')
  })

  it('notifies on an error', function() {
    spyOn(this.component, 'notify')
    this.component.updateGuide(this.url, {})
    request = jasmine.Ajax.requests.mostRecent()
    request.respondWith({  responseText: '', status: 500 })
    expect(this.component.notify).toHaveBeenCalledWith('Something went wrong')
  })

})
