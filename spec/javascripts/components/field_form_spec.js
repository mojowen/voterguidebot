describe('FieldsForm', function() {

  beforeEach(function() {
    var fields = [
      { name: (new Date())+' Field',
        element: 'input',
        example: '2016 [Your state / region] Voter Guide',
        limit: 40,
        id: 1 },
      { name: 'Great Field',
        element: 'textarea',
        example: 'Really long example',
        limit: 349,
        id: 2 }
    ]
    this.setUpComponent(FieldsForm, { fields: fields })
  })

  it('creates rows for the fields', function() {
    expect(this.dom.querySelectorAll('.mui-row').length).toEqual(2)
  })

  it('passes back errors to the rows')
})
