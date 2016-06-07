describe('Contest', function() {
  beforeEach(function() {
    this.props = {
      candidates: [],
      questions: []
    }
    this.setUpComponent(Contest, this.props)
  })

  it('initializes a new contest if empty props if null', function() {
    expect(this.component.state.candidates.length).toEqual(1)
  })

  describe('the title field', function() {
    it('is set by props')
    it('updates when changed')
  })

  describe('the description field', function() {
    it('is set by props')
    it('updates when changed')
  })

  describe('tracks candidates', function(){
    it('updates when changed')
    it('adds new candidates')
    it('deletes candidates')
  })

  describe('tracks questions', function(){
    it('updates when changed')
    it('adds new candidates')
    it('deletes candidates')
  })


})

