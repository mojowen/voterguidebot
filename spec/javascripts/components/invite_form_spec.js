describe('InviteForm', function() {
  var Utils = React.addons.TestUtils

  it('can render without error', function() {
    var component, element;

    element = React.createElement(InviteForm, {})

    expect(function() {
      component = Utils.renderIntoDocument(element);
    }).not.toThrow()
  })
})
