describe('ContestForm', function() {

  describe('for a new contest', function() {
    beforeEach(function() {
      this.setUpComponent(ContestForm, {})
    })
    it('initializes a new contest', function() {
      expect(this.dom.querySelectorAll('.contest').length).toEqual(1)
    })
    it('sets method to post', function() {
      expect(this.component.state.method).toEqual('post')
    })
    it('sets changed to true', function() {
      expect(this.component.state.changed).toEqual(true)
    })
    it('sets changed to true', function() {
      expect(this.component.state.autosave).toEqual(false)
    })

    it('sets new method on save', function() {
      Utils.Simulate.submit(this.component.refs.form_wrapper)

      var request = jasmine.Ajax.requests.mostRecent(),
          response = { contest: { id: 5 } }

      request.respondWith({ responseText: JSON.stringify(response),
                            status: 200 })

      expect(this.component.state.method).toEqual('patch')
    })
  })

  beforeEach(function() {
    this.contest = {}
    this.setUpComponent(ContestForm, { contest: this.contest })
    jasmine.Ajax.install()
  })

  afterEach(function() {
    jasmine.Ajax.uninstall()
  });

  it('submit updates contest', function() {
    spyOn(this.component, 'updateGuide')
    this.component.refs.contest.setState({candidates: [], questions: []})
    Utils.Simulate.submit(this.component.refs.form_wrapper)
    expect(this.component.updateGuide).toHaveBeenCalledWith(
      document.location.pathname,
      { contest: { title: '',
                   description: '',
                   candidates: [],
                   questions: [] }},
      jasmine.any(Function))
  })

  it('updates the state with a new object', function() {
    var contest = { candidates: [{ id: 5 }] }
    Utils.Simulate.submit(this.component.refs.form_wrapper)
    request = jasmine.Ajax.requests.mostRecent()
    spyOn(this.component, 'notify')
    expect(request.method).toBe('POST')
    request.respondWith({
      responseText: JSON.stringify({ contest: contest }),
      status: 200
    })
    expect(this.component.refs.contest.state.candidates).toEqual(
      contest.candidates)
  })

  it('sets new form settings on save', function() {
    Utils.Simulate.submit(this.component.refs.form_wrapper)

    var request = jasmine.Ajax.requests.mostRecent(),
        response = { url: 'this-url', contest: { id: 5 } }

    request.respondWith({ responseText: JSON.stringify(response),
                          status: 200 })

    expect(this.component.state.changed).toEqual(false)
    expect(this.component.state.url).toEqual(response.url)
  })

  it('cannot submit twice', function() {
    Utils.Simulate.submit(this.component.refs.form_wrapper)
    Utils.Simulate.submit(this.component.refs.form_wrapper)
    expect(jasmine.Ajax.requests.count()).toEqual(1)
  })

  it('failse to save')
})
