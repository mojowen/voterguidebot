var Utils = React.addons.TestUtils

beforeEach(function() {
  this.setUpComponent = function(reactElement, props) {
    this.element = React.createElement(reactElement, props)
    this.component = Utils.renderIntoDocument(this.element)
    this.dom = ReactDOM.findDOMNode(this.component)
  }
})
