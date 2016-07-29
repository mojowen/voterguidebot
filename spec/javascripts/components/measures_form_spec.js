describe('MeasuresForm', function() {

  beforeEach(function() {
    this.measures = { id: 1, candidates: [{ id: 5 }] }
    this.other_measures = { id: 2, candidates: [] }

    this.setUpComponent(MeasuresForm, {
      url: '/some/cool/url',
      measures: [this.measures, this.other_measures]
    })
    jasmine.Ajax.install()
  })

  afterEach(function() {
    jasmine.Ajax.uninstall()
  });

  it('displays a list of measures', function() {
    expect(this.dom.querySelectorAll('.measure--row').length).toEqual(2)
  })

  it('can delete a measures after confirmation', function() {
    Utils.Simulate.click(this.dom.querySelector('.remove'))
    swalSpy.confirmLast(true)

    var request = jasmine.Ajax.requests.mostRecent()
    expect(request.url).toBe('/some/cool/url/1.json');
    expect(request.method).toBe('DELETE')
    request.respondWith({ responseText: JSON.stringify(true),
                          status: 200 })

    expect(this.component.state.measures).toEqual([this.other_measures])
  })

  it('reorders measures after drag', function() {
    Utils.Simulate.dragStart(this.dom.querySelectorAll('.measure--row')[1])
    Utils.Simulate.dragOver(this.dom.querySelectorAll('.measure--row')[0])

    var request = jasmine.Ajax.requests.mostRecent()
    expect(request.url).toBe('/some/cool/url/position.json')
    expect(JSON.parse(request.params)).toEqual({ measures: [2, 1] })
    expect(request.method).toBe('PUT')
    request.respondWith({ responseText: JSON.stringify(true),
                          status: 200 })

    expect(this.component.state.measures).toEqual([this.other_measures, this.measures])
  })
})
