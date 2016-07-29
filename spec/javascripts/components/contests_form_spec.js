describe('ContestsForm', function() {

  beforeEach(function() {
    this.contest = { id: 1, candidates: [{ id: 5 }] }
    this.other_contest = { id: 2, candidates: [] }

    this.setUpComponent(ContestsForm, {
      url: '/some/cool/url',
      contests: [this.contest, this.other_contest]
    })
    jasmine.Ajax.install()
  })

  afterEach(function() {
    jasmine.Ajax.uninstall()
  });

  it('displays a list of contests', function() {
    expect(this.dom.querySelectorAll('.contest--row').length).toEqual(2)
  })

  it('can delete a contest after confirmation', function() {
    Utils.Simulate.click(this.dom.querySelector('.remove'))
    swalSpy.confirmLast(true)

    var request = jasmine.Ajax.requests.mostRecent()
    expect(request.url).toBe('/some/cool/url/1.json');
    expect(request.method).toBe('DELETE')
    request.respondWith({ responseText: JSON.stringify(true),
                          status: 200 })

    expect(this.component.state.contests).toEqual([this.other_contest])
  })

  it('reorders contests after drag', function() {
    Utils.Simulate.dragStart(this.dom.querySelectorAll('.contest--row')[1])
    Utils.Simulate.dragOver(this.dom.querySelectorAll('.contest--row')[0])

    var request = jasmine.Ajax.requests.mostRecent()
    expect(request.url).toBe('/some/cool/url/position.json')
    expect(JSON.parse(request.params)).toEqual({ contests: [2, 1] })
    expect(request.method).toBe('PUT')
    request.respondWith({ responseText: JSON.stringify(true),
                          status: 200 })

    expect(this.component.state.contests).toEqual([this.other_contest, this.contest])
  })
})
