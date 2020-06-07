//
//  PDFCreator.swift
//  DreamingJournals
//
//  Created by moesmoesie on 06/06/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import Foundation
import PDFKit
import CoreText

class PDFCreator{
    
    static func createDreamsPDF(dreams : [DreamViewModel]) -> Data {
        let pdfMetaData = [
            kCGPDFContextCreator: "Marnie",
            kCGPDFContextAuthor: "moesmoesie.com",
        ]
        
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]
        
        let pageRect = CGRect(x: 0, y: 0, width: 595.2, height: 841.8)
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        var pageNumber = 0
        let data = renderer.pdfData { (context) in
            for dream in dreams{
                pageNumber += 1
                var currentY : CGFloat = 0
                createNewPage(pageRect, context: context, pageNumber: pageNumber)
                drawDate(pageRect: pageRect, date: dream.wrapperDateString)
                drawAllSymbols(pageRect: pageRect, dream: dream)
                currentY = drawTitle(pageRect: pageRect, title: dream.title)
                currentY = drawAllTags(tags: dream.tags, pageRect: pageRect, y: currentY + 5)
                drawText(pageRect: pageRect, context: context, startY: currentY + 5, text: dream.text, pageNumber : &pageNumber)
            }
        }
        
        return data
    }
    
    static func createDreamPDF(dream : DreamViewModel) -> Data {
        let pdfMetaData = [
            kCGPDFContextCreator: "Marnie",
            kCGPDFContextAuthor: "moesmoesie.com",
            kCGPDFContextTitle : dream.title,
        ]
        
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]
        
        let pageRect = CGRect(x: 0, y: 0, width: 595.2, height: 841.8)
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        var currentY : CGFloat = 0
        var pageNumber = 1
 
        let data = renderer.pdfData { (context) in
            createNewPage(pageRect, context: context, pageNumber: 1)
            drawDate(pageRect: pageRect, date: dream.wrapperDateString)
            drawAllSymbols(pageRect: pageRect, dream: dream)
            currentY = drawTitle(pageRect: pageRect, title: dream.title)
            currentY = drawAllTags(tags: dream.tags, pageRect: pageRect, y: currentY + 5)
            drawText(pageRect: pageRect, context: context, startY: currentY + 5, text: dream.text, pageNumber: &pageNumber)
        }
        
        return data
    }
    
    static private func createNewPage(_ pageBounds: CGRect,context : UIGraphicsPDFRendererContext, pageNumber : Int){
        context.beginPage()
        drawBackground(pageBounds)
        drawPageNumber(pageRect: pageBounds, page: pageNumber)
    }
    
    static private func drawDate(pageRect : CGRect, date : String){
        let textFont = UIFont.secondarySmall
        let textAttributes: [NSAttributedString.Key: Any] =
            [
                NSAttributedString.Key.font: textFont,
                NSAttributedString.Key.foregroundColor : UIColor.main2
            ]

        let attributedText = NSAttributedString(
            string: date,
            attributes: textAttributes
        )

        let textStringSize = attributedText.size()

        let textStringRect = CGRect(
            x: 75,
            y: 55,
            width: textStringSize.width,
            height: textStringSize.height
        )

        attributedText.draw(in: textStringRect)
    }
    
    static private func drawPageNumber(pageRect : CGRect, page : Int){
        let textFont = UIFont.secondarySmall
        let textAttributes: [NSAttributedString.Key: Any] =
            [
                NSAttributedString.Key.font: textFont,
                NSAttributedString.Key.foregroundColor : UIColor.main2
            ]

        let attributedText = NSAttributedString(
            string: "\(page)",
            attributes: textAttributes
        )

        let textStringSize = attributedText.size()
        
        let textStringRect = CGRect(
            x: (pageRect.width - textStringSize.width) / 2.0,
            y: pageRect.height - 40,
            width: textStringSize.width,
            height: textStringSize.height
        )

        attributedText.draw(in: textStringRect)
    }
    
    static private func drawSymbol(image : UIImage, x : CGFloat, y : CGFloat) -> CGRect{
        let renderer = UIGraphicsImageRenderer(size: image.size)
        let coloredImage = renderer.image { context in
            UIColor.main1.setFill()
            image.draw(at: .zero)
            context.fill(
                CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height ),
                blendMode: .sourceAtop
            )
        }
        
        let maxHeight : CGFloat = 15
        let maxWidth : CGFloat = 15

        let aspectWidth = maxWidth / coloredImage.size.width
        let aspectHeight = maxHeight / coloredImage.size.height
        let aspectRatio = min(aspectWidth, aspectHeight)

        let scaledWidth = image.size.width * aspectRatio
        let scaledHeight = image.size.height * aspectRatio
        
        let ypos = y + ( (maxHeight / 2) - (scaledHeight / 2))
        
        let imageRect = CGRect(
            x: x,
            y: ypos,
            width: scaledWidth,
            height: scaledHeight
        )
        
        let original = CGRect(
            x: x,
            y: y,
            width: scaledWidth,
            height: scaledHeight
        )

        coloredImage.draw(in: imageRect)
        return original
    }
    
    static private func drawAllSymbols(pageRect : CGRect, dream : DreamViewModel){
        let x : CGFloat = pageRect.maxX - 75
        let y : CGFloat = 50
        
        var rect = CGRect(x: x - 10, y: y, width: 0, height: 0)
        
        if dream.isBookmarked{
            rect = drawSymbol(image: .bookmarkIcon, x : rect.minX - 25, y: rect.minY)
        }
        
        if dream.isLucid{
            rect = drawSymbol(image: .lucidIcon, x: rect.minX - 25, y: rect.minY)
        }
        
        if dream.isNightmare{
            rect = drawSymbol(image: .nightmareIcon, x: rect.minX - 25, y: rect.minY)
        }
    }
    
    static private func drawTitle(pageRect : CGRect, title : String) -> CGFloat{
        let textAttributes: [NSAttributedString.Key: Any] =
            [
                NSAttributedString.Key.font: UIFont.primaryLarge,
                NSAttributedString.Key.foregroundColor : UIColor.main1
            ]
        
        let attributedText = NSAttributedString(
          string: title,
          attributes: textAttributes
        )
        
        let textStringSize = attributedText.size()
        let maxWidth = pageRect.width - 200
        
        let textStringRect = CGRect(
          x: 75,
          y: 75,
          width: maxWidth,
          height: maxWidth < textStringSize.width ? textStringSize.height * 2.1 : textStringSize.height
        )
        
        attributedText.draw(in: textStringRect)
        return textStringRect.origin.y + textStringRect.size.height
    }
    
    static private func drawText(pageRect : CGRect, context : UIGraphicsPDFRendererContext, startY : CGFloat, text : String, pageNumber : inout Int){
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .natural
        paragraphStyle.lineBreakMode = .byWordWrapping
        
        let textAttributes: [NSAttributedString.Key: Any] =
            [
                NSAttributedString.Key.font: UIFont.primaryRegular,
                NSAttributedString.Key.foregroundColor : UIColor.main1,
                NSAttributedString.Key.paragraphStyle : paragraphStyle,
            ]
        
        let attributedText = NSAttributedString(
            string: text,
            attributes: textAttributes
        )
        
        var textStringRect = CGRect(
            x: 75,
            y: startY,
            width: pageRect.width - 150,
            height: pageRect.height - startY - 75
        )
        
        var pos = 0

        while pos < attributedText.length{
            let framesetter = CTFramesetterCreateWithAttributedString(attributedText as CFAttributedString)
            let path = CGMutablePath()
            path.addRect(textStringRect)
            let ctframe = CTFramesetterCreateFrame(framesetter, CFRangeMake(pos, 0), path, nil)
            let frameRange = CTFrameGetVisibleStringRange(ctframe)
            let text = (attributedText.attributedSubstring(from: NSRange(location: pos, length: frameRange.length)))
            
            pos += frameRange.length
            text.draw(in: textStringRect)
            
            
            if pos < attributedText.length{
                pageNumber += 1
                textStringRect = CGRect(
                    x: 75,
                    y: 75,
                    width: pageRect.width - 150,
                    height: pageRect.height - 150
                )
                createNewPage(pageRect, context: context,pageNumber: pageNumber)
            }
        }
    }
    
    static private func drawBackground(_ pageBounds: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        context.setFillColor(UIColor.background1.cgColor)
        context.fill(pageBounds)
    }
    
    static private func drawTag(_ pageBounds: CGRect, x : CGFloat, y: CGFloat, text : String) -> CGRect{
        guard let context = UIGraphicsGetCurrentContext() else {
            return CGRect(x: 0, y: 0, width: 0, height: 0)
        }
        
        let textAttributes: [NSAttributedString.Key: Any] =
            [
                NSAttributedString.Key.font: UIFont.secondaryRegular,
                NSAttributedString.Key.foregroundColor : UIColor.main1,
            ]
        
        let attributedText = NSAttributedString(
            string: text,
            attributes: textAttributes
        )
        
        let textSize = attributedText.size()
        var postionX: CGFloat = 0
        var postionY: CGFloat = 0
        
        if (x + textSize.width + 30) > pageBounds.width - 100{
            postionX = 75
            postionY = y + textSize.height + 10
        }else{
            postionX = x
            postionY = y
        }
        
        let capsuleRect = CGRect(
            x: postionX,
            y: postionY,
            width: textSize.width + 30,
            height: textSize.height + 5
        )
        
        let path = UIBezierPath(roundedRect: capsuleRect, cornerRadius: 12.5)
        
        let textRect = CGRect(
          x: capsuleRect.minX + 15,
          y: capsuleRect.minY + 2,
          width: textSize.width,
          height: textSize.height
        )
        
        context.addPath(path.cgPath)
        context.setFillColor(UIColor.background2.cgColor)
        context.fillPath()
        
        attributedText.draw(in: textRect)
        
        return capsuleRect
    }
    
    static private func drawAllTags(tags : [TagViewModel], pageRect : CGRect, y : CGFloat) -> CGFloat{
        var rect : CGRect = CGRect(x: 65, y: y, width: 0, height: 0)
        
        for tag in tags{
            rect = drawTag(pageRect, x : rect.maxX + 10, y: rect.minY, text : tag.text)
        }
        
        return rect.maxY
    }
}
