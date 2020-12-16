//
//  File.swift
//  Shortcuts
//
//  Created by Benno Kress on 16.12.20.
//

import Intents

class RenameFilesHandler: NSObject, RenameFilesIntentHandling {

    func handle(intent: RenameFilesIntent, completion: @escaping (RenameFilesIntentResponse) -> Void) {
        let response = RenameFilesIntentResponse()

        print("YO!")

        let files = intent.files ?? []
        let position = intent.position
        let changeCase = intent.changeCase?.boolValue ?? false
        guard let dateFormat = intent.dateFormat else {
            response.error = "Please choose a valid date format"
            return completion(response)
        }

        var outputArray = [INFile]()

        for file in files {
            var newName = file.filename

            if changeCase {
                let newCase = intent.newCase
                switch newCase {
                case .lowercase:
                    newName = newName.lowercased()
                case .uppercase:
                    newName = newName.uppercased()
                default:
                    response.error = "An invalid case was selected"
                    return completion(response)
                }
            }

            switch position {
            case .append:
                guard let fileURL = file.fileURL else {
                    response.error = "Couldn’t get file URL of \(file.filename)"
                    return completion(response)
                }
                let filePath = fileURL.deletingPathExtension().lastPathComponent
                let nameNoExt = FileManager.default.displayName(atPath: filePath)
                let ext = fileURL.pathExtension
                newName = "\(nameNoExt)_\(dateFormat).\(ext)"
            case .prepend:
                newName = "\(dateFormat)_\(newName)"
            default:
                response.error = "An invalid position was selected"
                return completion(response)
            }

            let renamedFile = INFile(data: file.data, filename: newName, typeIdentifier: file.typeIdentifier)
            outputArray.append(renamedFile)
        }

        response.result = outputArray
        completion(response)
    }

    func resolveFiles(for intent: RenameFilesIntent, with completion: @escaping ([RenameFilesFilesResolutionResult]) -> Void) {

        print("YO!")
        guard let resultArray = intent.files?.map({ RenameFilesFilesResolutionResult.success(with: $0) }), !resultArray.isEmpty else {
            return completion([RenameFilesFilesResolutionResult.unsupported(forReason: .noFiles)])
        }
        completion(resultArray)
    }

    func resolveDateFormat(for intent: RenameFilesIntent, with completion: @escaping (RenameFilesDateFormatResolutionResult) -> Void) {

        print("YO!")
        if let dateFormat = intent.dateFormat {
            completion(RenameFilesDateFormatResolutionResult.success(with: dateFormat))
        } else {
            completion(RenameFilesDateFormatResolutionResult.unsupported(forReason: .empty))
        }
    }

    func resolveChangeCase(for intent: RenameFilesIntent, with completion: @escaping (INBooleanResolutionResult) -> Void) {

        print("YO!")
        let changeCase = intent.changeCase?.boolValue ?? false
        completion(INBooleanResolutionResult.success(with: changeCase))
    }

    func resolveNewCase(for intent: RenameFilesIntent, with completion: @escaping (RenameCaseResolutionResult) -> Void) {

        print("YO!")
        let newCase = intent.newCase
        completion(RenameCaseResolutionResult.success(with: newCase))
    }

    func resolvePosition(for intent: RenameFilesIntent, with completion: @escaping (RenamePositionResolutionResult) -> Void) {

        print("YO!")
        let position = intent.position
        completion(RenamePositionResolutionResult.success(with: position))
    }

    func provideDateFormatOptionsCollection(for intent: RenameFilesIntent, with completion: @escaping (INObjectCollection<NSString>?, Error?) -> Void) {

        print("YO!")
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.calendar = Calendar.current
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let fullDate = dateFormatter.string(from: Date())
        let yearsAndMonths = String(fullDate.dropLast(3))
        let yearOnly = String(fullDate.dropLast(6))

        let options = INObjectCollection(items: [fullDate, yearsAndMonths, yearOnly].map { $0 as NSString })

        completion(options, nil)
    }

}
