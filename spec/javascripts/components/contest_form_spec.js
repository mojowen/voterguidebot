describe('FieldsForm', function() {

  beforeEach(function() {
    this.contests = []
    this.url = '/guide/1'
    this.setUpComponent(ContestForm, { contests: this.contests, url: this.url })
    jasmine.Ajax.install()
  })

  afterEach(function() {
    jasmine.Ajax.uninstall()
  });

  it('it renders all of the contests')
  it('initializes a new contest on click')
  it('on submit sends updates guide')
  it('collects all contests, candidates, and questions')
})
