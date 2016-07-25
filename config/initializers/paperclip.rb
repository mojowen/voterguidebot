Paperclip.interpolates :guide do |attachment, style|
  [attachment.instance.guide.name, attachment.instance.guide.id].join('_')
end
