var ImageComponent = React.createClass({
  getDefaultProps: function() {
    return {
      name: '',
      maxFiles: 1,
      onChangeCallback: function() { return true }
    }
  },
  getInitialState: function() {
    return { value: '' }
  },
  handleChange: function(file, data_url) {
    if( this.props.onChangeCallback(data_url) ) this.setState({ value: data_url })
  },
  componentDidMount: function() {
    var domNode = ReactDOM.findDOMNode(this),
        config = {
          paramName: this.props.name,
           maxFiles: this.props.maxFiles,
          previewTemplate: '<div></div>',
          url: '/get'
        }

    this.dropzone = new Dropzone(domNode, config)
    this.dropzone.on('thumbnail', this.handleChange);
  },
  render: function() {
    return <div className='image--field'></div>
  }
})
