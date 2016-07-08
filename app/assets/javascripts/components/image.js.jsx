var ImageComponent = React.createClass({
  getDefaultProps: function() {
    return {
      name: '',
      maxFiles: 1,
      onChange: function() { return true },
      preview: false,
      value: null
    }
  },
  getInitialState: function() {
    return { value: this.props.value }
  },
  handleError: function() {
    alert('Somethings gone wrong')
    this.handleChange(null)
  },
  handleThumbnail: function(file, dataURL) { this.handleChange(dataURL) },
  handleSuccess: function(file) {
    this.handleChange(JSON.parse(file.xhr.response).path)
  },
  handleChange: function(url) {
    this.props.onChange({ target: { value: url, name: this.props.name } })
    this.setState({ value: url })
  },
  handleClear: function(event) {
    this.handleChange(null)
    event.preventDefault()
  },
  pathname: function() {
    return document.location.pathname.toString()
  },
  include_guide_resource: function() {
    var match = this.pathname().match(/\/guides\/(\d+)/)
    if( match && match.length > 1 ) return '?guide_id='+match[1]
    return ''
  },
  componentDidMount: function() {
    var domNode = ReactDOM.findDOMNode(this.refs.dropzone),
        config = {
          headers: {
            'X-CSRF-Token': CSRF.token(),
            'Accept': 'application/json'
          },
          paramName: "upload[file]",
          maxFiles: this.props.maxFiles,
          previewTemplate: '<div></div>',
          url: '/uploads' + this.include_guide_resource()
        }

    this.dropzone = new Dropzone(domNode, config)
    this.dropzone.on('thumbnail', this.handleThumbnail)
    this.dropzone.on('success', this.handleSuccess)
    this.dropzone.on('error', this.handleError)
  },
  render: function() {
    var preview =  '',
        clear = ''
    if( this.props.preview && this.state.value ) {
      preview = <img src={this.state.value} />
    }

    if( this.state.value ) {
      var text = this.props.preview ? '' : ' Clear Image'
      clear = <a href="#" className='remove' onClick={this.handleClear}>
                <i className="fa fa-times" />{ text }
              </a>
    }

    return <div ref="dropzone" className='drop--zone image--field'>
      { clear }
      { preview }
    </div>
  }
})
