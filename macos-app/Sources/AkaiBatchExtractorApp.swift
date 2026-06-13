import AppKit
import Foundation
import SwiftUI
import UniformTypeIdentifiers

@main
struct AkaiBatchExtractorApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 900, minHeight: 620)
        }
        .windowStyle(.titleBar)
    }
}

let appDisplayName = "Vintage SampleCD Extractor"

enum AppLanguage: String, CaseIterable, Identifiable {
    case english
    case chinese
    case japanese

    var id: String { rawValue }

    var label: String {
        switch self {
        case .english: "English"
        case .chinese: "中文"
        case .japanese: "日本語"
        }
    }
}

enum StereoMode: CaseIterable, Identifiable {
    case keepMono
    case mergeStereo

    var id: String {
        switch self {
        case .keepMono: "keepMono"
        case .mergeStereo: "mergeStereo"
        }
    }
}

enum JobState: Equatable {
    case pending
    case running
    case done
    case failed(String)

    func label(language: AppLanguage) -> String {
        switch self {
        case .pending: Copy.pending(language)
        case .running: Copy.running(language)
        case .done: Copy.done(language)
        case .failed: Copy.failed(language)
        }
    }
}

enum Copy {
    static func initialLog(_ language: AppLanguage) -> String {
        switch language {
        case .english: "Drop Akai raw images / ISO files here, or click Add Images.\n"
        case .chinese: "把 Akai raw image / ISO 拖到这里，或点击“添加镜像”。\n"
        case .japanese: "Akai raw image / ISO ファイルをここにドロップするか、「イメージを追加」をクリックしてください。\n"
        }
    }

    static func subtitle(_ language: AppLanguage) -> String {
        switch language {
        case .english: "Batch extract WAV files from vintage Akai raw images / ISOs, with optional -L/-R mono pair stereo merging."
        case .chinese: "批量从老 Akai raw image / ISO 抽取 WAV，并可把 -L/-R mono 样本合并成立体声。"
        case .japanese: "古い Akai raw image / ISO から WAV を一括抽出し、必要に応じて -L/-R mono ペアを stereo WAV に結合します。"
        }
    }

    static func addImages(_ language: AppLanguage) -> String {
        switch language {
        case .english: "Add Images..."
        case .chinese: "添加镜像..."
        case .japanese: "イメージを追加..."
        }
    }

    static func clearQueue(_ language: AppLanguage) -> String {
        switch language {
        case .english: "Clear Queue"
        case .chinese: "清空队列"
        case .japanese: "キューを消去"
        }
    }

    static func fileCount(_ count: Int, language: AppLanguage) -> String {
        switch language {
        case .english: "\(count) file\(count == 1 ? "" : "s")"
        case .chinese: "\(count) 个文件"
        case .japanese: "\(count) ファイル"
        }
    }

    static func dropTitle(_ language: AppLanguage) -> String {
        switch language {
        case .english: "Drop one or more .iso / .img / .bin files here"
        case .chinese: "拖拽一个或多个 .iso / .img / .bin 到这里"
        case .japanese: "1つ以上の .iso / .img / .bin をここにドロップ"
        }
    }

    static func dropSubtitle(_ language: AppLanguage) -> String {
        switch language {
        case .english: "Source images are opened read-only and are never modified."
        case .chinese: "原始镜像只读访问，不会被修改。"
        case .japanese: "元のイメージは読み取り専用で開かれ、変更されません。"
        }
    }

    static func languageTitle(_ language: AppLanguage) -> String {
        switch language {
        case .english: "Language"
        case .chinese: "语言"
        case .japanese: "言語"
        }
    }

    static func outputSettings(_ language: AppLanguage) -> String {
        switch language {
        case .english: "Output Settings"
        case .chinese: "输出设置"
        case .japanese: "出力設定"
        }
    }

    static func stereoHandling(_ language: AppLanguage) -> String {
        switch language {
        case .english: "Stereo file handling"
        case .chinese: "立体声文件处理"
        case .japanese: "ステレオファイル処理"
        }
    }

    static func stereoMode(_ mode: StereoMode, language: AppLanguage) -> String {
        switch (mode, language) {
        case (.keepMono, .english): "Keep L/R as two mono files"
        case (.keepMono, .chinese): "保留 L/R 两个 mono 文件"
        case (.keepMono, .japanese): "L/R を2つの mono ファイルとして保持"
        case (.mergeStereo, .english): "Merge into one stereo WAV"
        case (.mergeStereo, .chinese): "合并成一个 stereo WAV"
        case (.mergeStereo, .japanese): "1つの stereo WAV に結合"
        }
    }

    static func outputDirectory(_ language: AppLanguage) -> String {
        switch language {
        case .english: "Output directory"
        case .chinese: "输出目录"
        case .japanese: "出力先フォルダ"
        }
    }

    static func defaultOutput(_ language: AppLanguage) -> String {
        switch language {
        case .english: "Default: create <image name>-WAV next to each image"
        case .chinese: "默认：每个镜像旁边生成 <镜像名>-WAV"
        case .japanese: "デフォルト：各イメージの横に <イメージ名>-WAV を作成"
        }
    }

    static func chooseDirectory(_ language: AppLanguage) -> String {
        switch language {
        case .english: "Choose Directory..."
        case .chinese: "选择目录..."
        case .japanese: "フォルダを選択..."
        }
    }

    static func useDefault(_ language: AppLanguage) -> String {
        switch language {
        case .english: "Use Default"
        case .chinese: "使用默认"
        case .japanese: "デフォルトを使用"
        }
    }

    static func startBatch(_ language: AppLanguage) -> String {
        switch language {
        case .english: "Start Batch"
        case .chinese: "开始批处理"
        case .japanese: "一括処理を開始"
        }
    }

    static func processing(_ language: AppLanguage) -> String {
        switch language {
        case .english: "Processing..."
        case .chinese: "正在处理..."
        case .japanese: "処理中..."
        }
    }

    static func logTitle(_ language: AppLanguage) -> String {
        switch language {
        case .english: "Log"
        case .chinese: "日志"
        case .japanese: "ログ"
        }
    }

    static func pending(_ language: AppLanguage) -> String {
        switch language {
        case .english: "Pending"
        case .chinese: "等待"
        case .japanese: "待機中"
        }
    }

    static func running(_ language: AppLanguage) -> String {
        switch language {
        case .english: "Running"
        case .chinese: "处理中"
        case .japanese: "処理中"
        }
    }

    static func done(_ language: AppLanguage) -> String {
        switch language {
        case .english: "Done"
        case .chinese: "完成"
        case .japanese: "完了"
        }
    }

    static func failed(_ language: AppLanguage) -> String {
        switch language {
        case .english: "Failed"
        case .chinese: "失败"
        case .japanese: "失敗"
        }
    }

    static func noImagesAdded(_ language: AppLanguage) -> String {
        switch language {
        case .english: "No supported image files were added. Supported: .iso / .img / .bin."
        case .chinese: "没有可添加的镜像文件。支持 .iso / .img / .bin。"
        case .japanese: "追加できるイメージファイルがありません。対応形式：.iso / .img / .bin。"
        }
    }

    static func imagesAdded(_ count: Int, language: AppLanguage) -> String {
        switch language {
        case .english: "Added \(count) image\(count == 1 ? "" : "s")."
        case .chinese: "已添加 \(count) 个镜像。"
        case .japanese: "\(count) 件のイメージを追加しました。"
        }
    }

    static func queueCleared(_ language: AppLanguage) -> String {
        switch language {
        case .english: "Queue cleared.\n"
        case .chinese: "队列已清空。\n"
        case .japanese: "キューを消去しました。\n"
        }
    }

    static func chooseImagesPanelTitle(_ language: AppLanguage) -> String {
        switch language {
        case .english: "Choose Akai Images"
        case .chinese: "选择 Akai 镜像"
        case .japanese: "Akai イメージを選択"
        }
    }

    static func chooseOutputPanelTitle(_ language: AppLanguage) -> String {
        switch language {
        case .english: "Choose Output Directory"
        case .chinese: "选择统一输出目录"
        case .japanese: "出力先フォルダを選択"
        }
    }

    static func outputRootSet(_ path: String, language: AppLanguage) -> String {
        switch language {
        case .english: "Output directory: \(path)"
        case .chinese: "统一输出目录：\(path)"
        case .japanese: "出力先フォルダ：\(path)"
        }
    }

    static func outputRootReset(_ language: AppLanguage) -> String {
        switch language {
        case .english: "Output directory reset: create <image name>-WAV next to each image."
        case .chinese: "输出目录已改为：每个镜像旁边生成 <镜像名>-WAV。"
        case .japanese: "出力先をリセット：各イメージの横に <イメージ名>-WAV を作成します。"
        }
    }

    static func noPendingJobs(_ language: AppLanguage) -> String {
        switch language {
        case .english: "There are no pending images in the queue."
        case .chinese: "队列里没有等待处理的镜像。"
        case .japanese: "キューに待機中のイメージはありません。"
        }
    }

    static func batchStarted(mode: StereoMode, language: AppLanguage) -> String {
        switch language {
        case .english: "Starting batch. Stereo handling: \(stereoMode(mode, language: language))"
        case .chinese: "开始批处理，立体声策略：\(stereoMode(mode, language: language))"
        case .japanese: "一括処理を開始します。ステレオ処理：\(stereoMode(mode, language: language))"
        }
    }

    static func batchFinished(_ language: AppLanguage) -> String {
        switch language {
        case .english: "Batch finished."
        case .chinese: "批处理结束。"
        case .japanese: "一括処理が完了しました。"
        }
    }

    static func outputPath(_ path: String, language: AppLanguage) -> String {
        switch language {
        case .english: "Output: \(path)"
        case .chinese: "输出：\(path)"
        case .japanese: "出力：\(path)"
        }
    }

    static func jobFinished(wav: Int, merged: Int, mono: Int, failed: Int, language: AppLanguage) -> String {
        switch language {
        case .english: "Done: WAV \(wav), merged \(merged), left as mono \(mono), merge failed \(failed)."
        case .chinese: "完成：WAV \(wav)，合并 \(merged)，保留 mono \(mono)，合并失败 \(failed)。"
        case .japanese: "完了：WAV \(wav)、結合 \(merged)、mono のまま \(mono)、結合失敗 \(failed)。"
        }
    }

    static func jobFailed(_ message: String, language: AppLanguage) -> String {
        switch language {
        case .english: "Failed: \(message)"
        case .chinese: "失败：\(message)"
        case .japanese: "失敗：\(message)"
        }
    }

    static func readingImage(_ language: AppLanguage) -> String {
        switch language {
        case .english: "Reading Akai image and converting samples to WAV tar..."
        case .chinese: "读取 Akai 镜像并转换为 WAV tar..."
        case .japanese: "Akai イメージを読み取り、サンプルを WAV tar に変換しています..."
        }
    }

    static func unpackingTar(_ language: AppLanguage) -> String {
        switch language {
        case .english: "Unpacking tar..."
        case .chinese: "解包 tar..."
        case .japanese: "tar を展開しています..."
        }
    }

    static func fixingPermissions(_ language: AppLanguage) -> String {
        switch language {
        case .english: "Fixing output directory permissions..."
        case .chinese: "修复输出目录权限..."
        case .japanese: "出力フォルダの権限を修正しています..."
        }
    }

    static func mergingStereo(_ language: AppLanguage) -> String {
        switch language {
        case .english: "Scanning -L/-R mono WAV pairs and merging stereo files..."
        case .chinese: "扫描 -L/-R mono WAV 并合并成立体声..."
        case .japanese: "-L/-R mono WAV ペアをスキャンして stereo ファイルに結合しています..."
        }
    }

    static func stereoSummary(_ summary: StereoMergeSummary, language: AppLanguage) -> String {
        switch language {
        case .english: "stereo merged: \(summary.merged), left as mono: \(summary.skipped), failed: \(summary.failed)"
        case .chinese: "stereo merged: \(summary.merged), left as mono: \(summary.skipped), failed: \(summary.failed)"
        case .japanese: "stereo 結合: \(summary.merged), mono のまま: \(summary.skipped), 失敗: \(summary.failed)"
        }
    }

    static func keepingMono(_ language: AppLanguage) -> String {
        switch language {
        case .english: "Keeping L/R mono files as selected."
        case .chinese: "按设置保留 L/R mono 文件。"
        case .japanese: "設定どおり L/R mono ファイルを保持します。"
        }
    }

    static func mergeFailed(_ file: String, _ message: String, language: AppLanguage) -> String {
        switch language {
        case .english: "Merge failed: \(file) - \(message)"
        case .chinese: "合并失败：\(file) - \(message)"
        case .japanese: "結合失敗：\(file) - \(message)"
        }
    }

    static func missingAkaiutil(_ paths: [String]) -> String {
        "Bundled akaiutil was not found. Checked:\n" + paths.joined(separator: "\n")
    }

    static func notAkaiImage(_ language: AppLanguage) -> String {
        switch language {
        case .english:
            "This looks like a standard ISO9660 disc image, not an Akai sampler image. A normal ISO opens directly in Finder (double-click) or with `hdiutil attach`. This app only handles Akai S900/S1000/S3000 sampler discs, which macOS cannot mount on its own."
        case .chinese:
            "这看起来是标准的 ISO9660 光盘镜像，不是 Akai 采样器镜像。普通 ISO 直接在访达里双击即可挂载（或用 `hdiutil attach`）。本工具只处理 macOS 自身无法挂载的 Akai S900/S1000/S3000 采样器光盘。"
        case .japanese:
            "これは標準的な ISO9660 ディスクイメージのようで、Akai サンプラーのイメージではありません。通常の ISO は Finder でダブルクリックすればマウントできます（または `hdiutil attach`）。本アプリは macOS が単体でマウントできない Akai S900/S1000/S3000 サンプラーディスク専用です。"
        }
    }
}

struct ExtractionJob: Identifiable, Equatable {
    let id = UUID()
    let imageURL: URL
    var outputURL: URL?
    var state: JobState = .pending
    var wavCount: Int = 0
    var mergedCount: Int = 0
    var skippedCount: Int = 0
    var failedMergeCount: Int = 0
}

@MainActor
final class AppModel: ObservableObject {
    @Published var jobs: [ExtractionJob] = []
    @Published var language: AppLanguage = .english {
        didSet {
            if jobs.isEmpty && log == Copy.initialLog(oldValue) {
                log = Copy.initialLog(language)
            }
        }
    }
    @Published var stereoMode: StereoMode = .mergeStereo
    @Published var outputRoot: URL?
    @Published var isRunning = false
    @Published var log = Copy.initialLog(.english)

    func addFiles(_ urls: [URL]) {
        let imageURLs = urls
            .filter { Self.isSupportedImage($0) }
            .filter { incoming in !jobs.contains { $0.imageURL == incoming } }
            .sorted { $0.lastPathComponent.localizedStandardCompare($1.lastPathComponent) == .orderedAscending }

        guard !imageURLs.isEmpty else {
            appendLog(Copy.noImagesAdded(language))
            return
        }

        jobs.append(contentsOf: imageURLs.map { ExtractionJob(imageURL: $0) })
        appendLog(Copy.imagesAdded(imageURLs.count, language: language))
    }

    func clearFinishedOrAll() {
        if isRunning { return }
        jobs.removeAll()
        log = Copy.queueCleared(language)
    }

    func chooseImages() {
        let panel = NSOpenPanel()
        panel.title = Copy.chooseImagesPanelTitle(language)
        panel.allowsMultipleSelection = true
        panel.canChooseDirectories = false
        panel.canChooseFiles = true
        panel.allowedContentTypes = [.diskImage, .data]
        if panel.runModal() == .OK {
            addFiles(panel.urls)
        }
    }

    func chooseOutputRoot() {
        let panel = NSOpenPanel()
        panel.title = Copy.chooseOutputPanelTitle(language)
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        panel.allowsMultipleSelection = false
        if panel.runModal() == .OK, let url = panel.url {
            outputRoot = url
            appendLog(Copy.outputRootSet(url.path, language: language))
        }
    }

    func resetOutputRoot() {
        outputRoot = nil
        appendLog(Copy.outputRootReset(language))
    }

    func runBatch() {
        guard !isRunning else { return }
        guard jobs.contains(where: { $0.state == .pending }) else {
            appendLog(Copy.noPendingJobs(language))
            return
        }

        isRunning = true
        let runLanguage = language
        appendLog(Copy.batchStarted(mode: stereoMode, language: runLanguage))

        Task {
            for index in jobs.indices where jobs[index].state == .pending {
                await runJob(at: index, language: runLanguage)
            }
            isRunning = false
            appendLog(Copy.batchFinished(runLanguage))
        }
    }

    private func runJob(at index: Int, language: AppLanguage) async {
        jobs[index].state = .running
        let imageURL = jobs[index].imageURL
        let outputURL = Self.outputURL(for: imageURL, outputRoot: outputRoot)
        jobs[index].outputURL = outputURL

        appendLog("")
        appendLog("== \(imageURL.lastPathComponent)")
        appendLog(Copy.outputPath(outputURL.path, language: language))

        do {
            let result = try await AkaiExtractor.extract(
                imageURL: imageURL,
                outputURL: outputURL,
                stereoMode: stereoMode,
                language: language,
                log: { [weak self] line in
                    Task { @MainActor in self?.appendLog(line) }
                }
            )
            jobs[index].wavCount = result.wavCount
            jobs[index].mergedCount = result.stereoSummary?.merged ?? 0
            jobs[index].skippedCount = result.stereoSummary?.skipped ?? 0
            jobs[index].failedMergeCount = result.stereoSummary?.failed ?? 0
            jobs[index].state = .done
            appendLog(Copy.jobFinished(
                wav: result.wavCount,
                merged: jobs[index].mergedCount,
                mono: jobs[index].skippedCount,
                failed: jobs[index].failedMergeCount,
                language: language
            ))
        } catch {
            jobs[index].state = .failed(error.localizedDescription)
            appendLog(Copy.jobFailed(error.localizedDescription, language: language))
        }
    }

    private func appendLog(_ line: String) {
        log += line + "\n"
    }

    private static func isSupportedImage(_ url: URL) -> Bool {
        let ext = url.pathExtension.lowercased()
        return ["iso", "img", "bin"].contains(ext)
    }

    private static func outputURL(for imageURL: URL, outputRoot: URL?) -> URL {
        let base = imageURL.deletingPathExtension().lastPathComponent
        let folder = FileName.sanitized(base) + "-WAV"
        if let outputRoot {
            return outputRoot.appendingPathComponent(folder, isDirectory: true)
        }
        return imageURL.deletingLastPathComponent().appendingPathComponent(folder, isDirectory: true)
    }
}

struct ContentView: View {
    @StateObject private var model = AppModel()
    @State private var isDropTargeted = false

    var body: some View {
        HStack(spacing: 0) {
            leftPane
                .frame(minWidth: 470)
            Divider()
            rightPane
                .frame(minWidth: 360)
        }
    }

    private var leftPane: some View {
        VStack(alignment: .leading, spacing: 14) {
            VStack(alignment: .leading, spacing: 6) {
                Text(appDisplayName)
                    .font(.system(size: 28, weight: .semibold))
                Text(Copy.subtitle(model.language))
                    .foregroundStyle(.secondary)
            }

            dropZone

            HStack {
                Button(Copy.addImages(model.language)) { model.chooseImages() }
                Button(Copy.clearQueue(model.language)) { model.clearFinishedOrAll() }
                    .disabled(model.isRunning || model.jobs.isEmpty)
                Spacer()
                Text(Copy.fileCount(model.jobs.count, language: model.language))
                    .foregroundStyle(.secondary)
            }

            jobList
        }
        .padding(22)
    }

    private var dropZone: some View {
        RoundedRectangle(cornerRadius: 8)
            .strokeBorder(isDropTargeted ? Color.accentColor : Color.secondary.opacity(0.45), style: StrokeStyle(lineWidth: 2, dash: [8, 6]))
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isDropTargeted ? Color.accentColor.opacity(0.10) : Color.secondary.opacity(0.06))
            )
            .overlay {
                VStack(spacing: 8) {
                    Image(systemName: "square.and.arrow.down.on.square")
                        .font(.system(size: 32))
                        .foregroundStyle(isDropTargeted ? Color.accentColor : Color.secondary)
                    Text(Copy.dropTitle(model.language))
                        .font(.headline)
                    Text(Copy.dropSubtitle(model.language))
                        .foregroundStyle(.secondary)
                }
            }
            .frame(height: 150)
            .onDrop(of: [UTType.fileURL.identifier], isTargeted: $isDropTargeted) { providers in
                loadDroppedFiles(providers)
                return true
            }
    }

    private var jobList: some View {
        List {
            ForEach(model.jobs) { job in
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Text(job.imageURL.lastPathComponent)
                            .font(.headline)
                            .lineLimit(1)
                        Spacer()
                        statusView(job.state)
                    }
                    if let outputURL = job.outputURL {
                        Text(outputURL.path)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    } else {
                        Text(job.imageURL.path)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                    if case .failed(let message) = job.state {
                        Text(message)
                            .font(.caption)
                            .foregroundStyle(.red)
                            .lineLimit(2)
                    }
                }
                .padding(.vertical, 5)
            }
        }
        .listStyle(.inset)
    }

    private var rightPane: some View {
        VStack(alignment: .leading, spacing: 16) {
            GroupBox(Copy.languageTitle(model.language)) {
                Picker(Copy.languageTitle(model.language), selection: $model.language) {
                    ForEach(AppLanguage.allCases) { language in
                        Text(language.label).tag(language)
                    }
                }
                .pickerStyle(.segmented)
                .labelsHidden()
                .disabled(model.isRunning)
                .padding(4)
            }

            GroupBox(Copy.outputSettings(model.language)) {
                VStack(alignment: .leading, spacing: 12) {
                    Picker(Copy.stereoHandling(model.language), selection: $model.stereoMode) {
                        ForEach(StereoMode.allCases) { mode in
                            Text(Copy.stereoMode(mode, language: model.language)).tag(mode)
                        }
                    }
                    .pickerStyle(.radioGroup)
                    .disabled(model.isRunning)

                    Divider()

                    Text(Copy.outputDirectory(model.language))
                        .font(.headline)
                    Text(model.outputRoot?.path ?? Copy.defaultOutput(model.language))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)

                    HStack {
                        Button(Copy.chooseDirectory(model.language)) { model.chooseOutputRoot() }
                            .disabled(model.isRunning)
                        Button(Copy.useDefault(model.language)) { model.resetOutputRoot() }
                            .disabled(model.isRunning || model.outputRoot == nil)
                    }
                }
                .padding(4)
            }

            Button {
                model.runBatch()
            } label: {
                Label(model.isRunning ? Copy.processing(model.language) : Copy.startBatch(model.language), systemImage: "play.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .disabled(model.isRunning || model.jobs.isEmpty)

            GroupBox(Copy.logTitle(model.language)) {
                ScrollViewReader { proxy in
                    ScrollView {
                        Text(model.log)
                            .font(.system(.caption, design: .monospaced))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .textSelection(.enabled)
                            .id("log-end")
                    }
                    .onChange(of: model.log) { _ in
                        proxy.scrollTo("log-end", anchor: .bottom)
                    }
                }
                .frame(maxHeight: .infinity)
            }
        }
        .padding(22)
    }

    private func statusView(_ state: JobState) -> some View {
        let color: Color = switch state {
        case .pending: .secondary
        case .running: .accentColor
        case .done: .green
        case .failed: .red
        }

        return Text(state.label(language: model.language))
            .font(.caption.weight(.semibold))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color.opacity(0.14), in: Capsule())
            .foregroundStyle(color)
    }

    private func loadDroppedFiles(_ providers: [NSItemProvider]) {
        for provider in providers {
            provider.loadItem(forTypeIdentifier: UTType.fileURL.identifier, options: nil) { item, _ in
                let url: URL?
                if let data = item as? Data {
                    url = URL(dataRepresentation: data, relativeTo: nil)
                } else if let nsURL = item as? NSURL {
                    url = nsURL as URL
                } else {
                    url = nil
                }

                if let url {
                    DispatchQueue.main.async {
                        model.addFiles([url])
                    }
                }
            }
        }
    }
}

struct ExtractionResult {
    let wavCount: Int
    let stereoSummary: StereoMergeSummary?
}

struct StereoMergeSummary {
    var merged = 0
    var skipped = 0
    var failed = 0
}

enum AppError: LocalizedError {
    case missingAkaiutil([String])
    case processFailed(String, Int32, String)
    case invalidWav(String)
    case notAkaiImage(String)

    var errorDescription: String? {
        switch self {
        case .missingAkaiutil(let paths):
            return Copy.missingAkaiutil(paths)
        case .processFailed(let command, let status, let output):
            return "\(command) exited with status \(status).\(output.isEmpty ? "" : "\n\(output)")"
        case .invalidWav(let message):
            return message
        case .notAkaiImage(let message):
            return message
        }
    }
}

enum ImageFormat {
    /// Akai sampler images are NOT ISO9660. If the file carries the ISO9660
    /// "CD001" volume-descriptor signature at offset 0x8001, it's a normal disc
    /// image that akaiutil cannot read — surface a friendly message instead of
    /// letting akaiutil emit cryptic "invalid partition" / "tar error" output.
    static func ensureAkaiImage(_ url: URL, language: AppLanguage) throws {
        guard let handle = try? FileHandle(forReadingFrom: url) else { return }
        defer { try? handle.close() }
        guard (try? handle.seek(toOffset: 0x8000)) != nil else { return }
        let bytes = [UInt8](handle.readData(ofLength: 6))
        guard bytes.count == 6 else { return }
        // byte 0 = volume-descriptor type; bytes 1...5 spell "CD001"
        if bytes[1] == 0x43, bytes[2] == 0x44, bytes[3] == 0x30, bytes[4] == 0x30, bytes[5] == 0x31 {
            throw AppError.notAkaiImage(Copy.notAkaiImage(language))
        }
    }
}

enum AkaiExtractor {
    static func extract(
        imageURL: URL,
        outputURL: URL,
        stereoMode: StereoMode,
        language: AppLanguage,
        log: @escaping (String) -> Void
    ) async throws -> ExtractionResult {
        try ImageFormat.ensureAkaiImage(imageURL, language: language)
        let akaiutil = try ToolLocator.akaiutil()
        let fileManager = FileManager.default
        try fileManager.createDirectory(at: outputURL, withIntermediateDirectories: true)

        let tarURL = fileManager.temporaryDirectory
            .appendingPathComponent("akai-\(UUID().uuidString)")
            .appendingPathExtension("tar")
        defer { try? fileManager.removeItem(at: tarURL) }

        log(Copy.readingImage(language))
        let akaiOutput = try await ProcessRunner.run(
            executableURL: akaiutil,
            arguments: ["-r", imageURL.path],
            standardInput: "cd /disk0\ntarcwav \(tarURL.path)\nexit\n"
        )
        if !akaiOutput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            log(akaiOutput.trimmingCharacters(in: .whitespacesAndNewlines))
        }

        log(Copy.unpackingTar(language))
        _ = try await ProcessRunner.run(
            executableURL: URL(fileURLWithPath: "/usr/bin/tar"),
            arguments: ["-xf", tarURL.path, "-C", outputURL.path],
            standardInput: nil
        )

        log(Copy.fixingPermissions(language))
        _ = try await ProcessRunner.run(
            executableURL: URL(fileURLWithPath: "/bin/chmod"),
            arguments: ["-R", "u+rwX", outputURL.path],
            standardInput: nil
        )

        var stereoSummary: StereoMergeSummary?
        if stereoMode == .mergeStereo {
            log(Copy.mergingStereo(language))
            stereoSummary = try StereoMerger.mergeStereoPairs(in: outputURL, language: language, log: log)
            if let stereoSummary {
                log(Copy.stereoSummary(stereoSummary, language: language))
            }
        } else {
            log(Copy.keepingMono(language))
        }

        let wavCount = FileCounter.countWavs(in: outputURL)
        return ExtractionResult(wavCount: wavCount, stereoSummary: stereoSummary)
    }
}

enum ToolLocator {
    static func akaiutil() throws -> URL {
        let bundleCandidate = Bundle.main.resourceURL?.appendingPathComponent("Tools/akaiutil")
        let devCandidate = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
            .appendingPathComponent("AppResources/Tools/akaiutil")
        let homeBuildCandidate = URL(fileURLWithPath: NSHomeDirectory())
            .appendingPathComponent("akaiutil-build/akaiutil")

        let candidates = [bundleCandidate, devCandidate, homeBuildCandidate].compactMap { $0 }
        for candidate in candidates where FileManager.default.isExecutableFile(atPath: candidate.path) {
            return candidate
        }
        throw AppError.missingAkaiutil(candidates.map(\.path))
    }
}

enum ProcessRunner {
    static func run(
        executableURL: URL,
        arguments: [String],
        standardInput: String?
    ) async throws -> String {
        try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    let process = Process()
                    let outputPipe = Pipe()
                    let inputPipe = Pipe()
                    process.executableURL = executableURL
                    process.arguments = arguments
                    process.standardOutput = outputPipe
                    process.standardError = outputPipe
                    if standardInput != nil {
                        process.standardInput = inputPipe
                    }

                    try process.run()
                    if let standardInput, let data = standardInput.data(using: .utf8) {
                        inputPipe.fileHandleForWriting.write(data)
                        try? inputPipe.fileHandleForWriting.close()
                    }

                    let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
                    process.waitUntilExit()
                    let output = String(data: outputData, encoding: .utf8) ?? ""

                    if process.terminationStatus == 0 {
                        continuation.resume(returning: output)
                    } else {
                        let command = ([executableURL.path] + arguments).joined(separator: " ")
                        continuation.resume(throwing: AppError.processFailed(command, process.terminationStatus, output))
                    }
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}

enum FileCounter {
    static func countWavs(in root: URL) -> Int {
        guard let enumerator = FileManager.default.enumerator(
            at: root,
            includingPropertiesForKeys: [.isRegularFileKey],
            options: [.skipsHiddenFiles]
        ) else {
            return 0
        }

        var count = 0
        for case let url as URL in enumerator where url.pathExtension.lowercased() == "wav" {
            count += 1
        }
        return count
    }
}

enum StereoMerger {
    static func mergeStereoPairs(in root: URL, language: AppLanguage, log: (String) -> Void) throws -> StereoMergeSummary {
        guard let enumerator = FileManager.default.enumerator(
            at: root,
            includingPropertiesForKeys: [.isRegularFileKey],
            options: [.skipsHiddenFiles]
        ) else {
            return StereoMergeSummary()
        }

        var leftFiles: [URL] = []
        for case let url as URL in enumerator where url.lastPathComponent.lowercased().hasSuffix("-l.wav") {
            leftFiles.append(url)
        }

        var summary = StereoMergeSummary()
        for leftURL in leftFiles.sorted(by: { $0.path.localizedStandardCompare($1.path) == .orderedAscending }) {
            guard let pair = rightAndOutputURLs(forLeftURL: leftURL) else {
                summary.skipped += 1
                continue
            }

            guard FileManager.default.fileExists(atPath: pair.right.path) else {
                summary.skipped += 1
                continue
            }

            do {
                try WavStereoWriter.merge(leftURL: leftURL, rightURL: pair.right, outputURL: pair.output)
                try FileManager.default.removeItem(at: leftURL)
                try FileManager.default.removeItem(at: pair.right)
                summary.merged += 1
            } catch {
                log(Copy.mergeFailed(leftURL.lastPathComponent, error.localizedDescription, language: language))
                summary.failed += 1
            }
        }

        return summary
    }

    private static func rightAndOutputURLs(forLeftURL leftURL: URL) -> (right: URL, output: URL)? {
        let name = leftURL.lastPathComponent
        let lower = name.lowercased()
        guard lower.hasSuffix("-l.wav") else { return nil }

        let stemLength = name.count - "-L.wav".count
        let stem = String(name.prefix(stemLength))
        let rightName = stem + "-R.wav"
        let outputName = FileName.rstripWhitespace(stem) + ".wav"
        let directory = leftURL.deletingLastPathComponent()
        return (
            directory.appendingPathComponent(rightName),
            directory.appendingPathComponent(outputName)
        )
    }
}

enum WavStereoWriter {
    struct MonoWav {
        let sampleRate: UInt32
        let bitsPerSample: UInt16
        let samples: Data
    }

    static func merge(leftURL: URL, rightURL: URL, outputURL: URL) throws {
        let left = try readMonoPCM16(leftURL)
        let right = try readMonoPCM16(rightURL)

        guard left.sampleRate == right.sampleRate else {
            throw AppError.invalidWav("Left and right sample rates do not match.")
        }
        guard left.bitsPerSample == right.bitsPerSample else {
            throw AppError.invalidWav("Left and right bit depths do not match.")
        }
        guard left.samples.count == right.samples.count else {
            throw AppError.invalidWav("Left and right sample lengths do not match.")
        }
        guard left.samples.count % 2 == 0 else {
            throw AppError.invalidWav("WAV sample data is not aligned to 16-bit samples.")
        }

        var interleaved = Data(capacity: left.samples.count * 2)
        var offset = 0
        while offset < left.samples.count {
            interleaved.append(left.samples[offset])
            interleaved.append(left.samples[offset + 1])
            interleaved.append(right.samples[offset])
            interleaved.append(right.samples[offset + 1])
            offset += 2
        }

        let stereo = makePCM16StereoWav(sampleRate: left.sampleRate, audioData: interleaved)
        let tempURL = outputURL.deletingLastPathComponent()
            .appendingPathComponent(".stereo_tmp_\(UUID().uuidString).wav")
        try stereo.write(to: tempURL, options: .atomic)
        if FileManager.default.fileExists(atPath: outputURL.path) {
            try FileManager.default.removeItem(at: outputURL)
        }
        try FileManager.default.moveItem(at: tempURL, to: outputURL)
    }

    private static func readMonoPCM16(_ url: URL) throws -> MonoWav {
        let data = try Data(contentsOf: url)
        guard data.count >= 44 else {
            throw AppError.invalidWav("WAV file is too small: \(url.lastPathComponent)")
        }
        guard data.ascii(0, 4) == "RIFF", data.ascii(8, 4) == "WAVE" else {
            throw AppError.invalidWav("Not a RIFF/WAVE file: \(url.lastPathComponent)")
        }

        var cursor = 12
        var channels: UInt16?
        var sampleRate: UInt32?
        var bitsPerSample: UInt16?
        var audioFormat: UInt16?
        var sampleData: Data?

        while cursor + 8 <= data.count {
            let id = data.ascii(cursor, 4)
            let size = Int(data.uint32LE(cursor + 4))
            let chunkStart = cursor + 8
            let chunkEnd = chunkStart + size
            guard chunkEnd <= data.count else { break }

            if id == "fmt " {
                guard size >= 16 else {
                    throw AppError.invalidWav("fmt chunk 太短：\(url.lastPathComponent)")
                }
                audioFormat = data.uint16LE(chunkStart)
                channels = data.uint16LE(chunkStart + 2)
                sampleRate = data.uint32LE(chunkStart + 4)
                bitsPerSample = data.uint16LE(chunkStart + 14)
            } else if id == "data" {
                sampleData = data.subdata(in: chunkStart..<chunkEnd)
            }

            cursor = chunkEnd + (size % 2)
        }

        guard audioFormat == 1 else {
            throw AppError.invalidWav("Only PCM WAV files are supported: \(url.lastPathComponent)")
        }
        guard channels == 1 else {
            throw AppError.invalidWav("Only mono WAV files can be merged: \(url.lastPathComponent)")
        }
        guard bitsPerSample == 16 else {
            throw AppError.invalidWav("Only 16-bit WAV files are supported: \(url.lastPathComponent)")
        }
        guard let sampleRate, let bitsPerSample, let sampleData else {
            throw AppError.invalidWav("WAV file is missing fmt or data chunk: \(url.lastPathComponent)")
        }

        return MonoWav(sampleRate: sampleRate, bitsPerSample: bitsPerSample, samples: sampleData)
    }

    private static func makePCM16StereoWav(sampleRate: UInt32, audioData: Data) -> Data {
        let channels: UInt16 = 2
        let bitsPerSample: UInt16 = 16
        let blockAlign = channels * bitsPerSample / 8
        let byteRate = sampleRate * UInt32(blockAlign)
        let dataSize = UInt32(audioData.count)
        let riffSize = UInt32(36) + dataSize

        var out = Data()
        out.appendASCII("RIFF")
        out.appendUInt32LE(riffSize)
        out.appendASCII("WAVE")
        out.appendASCII("fmt ")
        out.appendUInt32LE(16)
        out.appendUInt16LE(1)
        out.appendUInt16LE(channels)
        out.appendUInt32LE(sampleRate)
        out.appendUInt32LE(byteRate)
        out.appendUInt16LE(blockAlign)
        out.appendUInt16LE(bitsPerSample)
        out.appendASCII("data")
        out.appendUInt32LE(dataSize)
        out.append(audioData)
        return out
    }
}

enum FileName {
    static func sanitized(_ input: String) -> String {
        let forbidden = CharacterSet(charactersIn: "/:")
        let parts = input.components(separatedBy: forbidden).filter { !$0.isEmpty }
        let value = parts.joined(separator: "-")
        return value.isEmpty ? "Akai-Image" : value
    }

    static func rstripWhitespace(_ input: String) -> String {
        var value = input
        while value.last?.isWhitespace == true {
            value.removeLast()
        }
        return value
    }
}

extension Data {
    func ascii(_ offset: Int, _ length: Int) -> String {
        guard offset >= 0, offset + length <= count else { return "" }
        return String(data: subdata(in: offset..<(offset + length)), encoding: .ascii) ?? ""
    }

    func uint16LE(_ offset: Int) -> UInt16 {
        UInt16(self[offset]) | (UInt16(self[offset + 1]) << 8)
    }

    func uint32LE(_ offset: Int) -> UInt32 {
        UInt32(self[offset])
            | (UInt32(self[offset + 1]) << 8)
            | (UInt32(self[offset + 2]) << 16)
            | (UInt32(self[offset + 3]) << 24)
    }

    mutating func appendASCII(_ string: String) {
        append(string.data(using: .ascii) ?? Data())
    }

    mutating func appendUInt16LE(_ value: UInt16) {
        append(UInt8(value & 0xff))
        append(UInt8((value >> 8) & 0xff))
    }

    mutating func appendUInt32LE(_ value: UInt32) {
        append(UInt8(value & 0xff))
        append(UInt8((value >> 8) & 0xff))
        append(UInt8((value >> 16) & 0xff))
        append(UInt8((value >> 24) & 0xff))
    }
}
