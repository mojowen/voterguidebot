describe('MeasureForm', function() {

  describe('for a new contest', function() {
    beforeEach(function() {
      this.setUpComponent(MeasureForm, {})
    })
    it('initializes a new measure', function() {
      expect(this.dom.querySelectorAll('.measure').length).toEqual(1)
    })
    it('sets method to post', function() {
      expect(this.component.state.method).toEqual('post')
    })
  })

  beforeEach(function() {
    this.contests = {}
    this.setUpComponent(MeasureForm, { contest: this.contests })
    jasmine.Ajax.install()
  })

  afterEach(function() {
    jasmine.Ajax.uninstall()
  });

  it('submit updates measure', function() {
    spyOn(this.component, 'updateGuide')

    Utils.Simulate.submit(this.component.refs.form_wrapper)
    expect(this.component.updateGuide).toHaveBeenCalledWith(
      document.location.pathname,
      { measure: { title: '',
                   description: '',
                   yes_means: '',
                   no_means: '',
                   endorsements: [] }},
      jasmine.any(Function))
  })

  it('updates the state with a new object', function() {
    var measure = { title: 'new' }
    Utils.Simulate.submit(this.component.refs.form_wrapper)
    request = jasmine.Ajax.requests.mostRecent()
    spyOn(this.component, 'notify')
    expect(request.method).toBe('POST')
    request.respondWith({
      responseText: JSON.stringify({ state: { measure: measure }}),
      status: 200
    })
    expect(this.component.refs.measure.state.title).toEqual(
      measure.title)
  })

})
