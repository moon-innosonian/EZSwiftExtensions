//
//  BlockWebView.swift
//
//
//  Created by Cem Olcay on 12/08/15.
//
//

#if os(iOS)

import WebKit

open class BlockWebView: WKWebView, WKNavigationDelegate {

    open var didStartLoad: ((URLRequest) -> Void)?
    open var didFinishLoad: ((URLRequest) -> Void)?
    open var didFailLoad: ((URLRequest, Error) -> Void)?
    open var shouldStartLoadingRequest: ((URLRequest) -> Bool)?

    public override init(frame: CGRect, configuration: WKWebViewConfiguration = WKWebViewConfiguration()) {
        super.init(frame: frame, configuration: configuration)
        self.navigationDelegate = self
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.navigationDelegate = self
    }

    // MARK: - WKNavigationDelegate

    open func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
                      decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

        if let should = shouldStartLoadingRequest,
           let request = navigationAction.request as URLRequest? {
            let allow = should(request)
            decisionHandler(allow ? .allow : .cancel)
        } else {
            decisionHandler(.allow)
        }
    }

    open func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        if let request = webView.url.map({ URLRequest(url: $0) }) {
            didStartLoad?(request)
        }
    }

    open func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if let request = webView.url.map({ URLRequest(url: $0) }) {
            didFinishLoad?(request)
        }
    }

    open func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        if let request = webView.url.map({ URLRequest(url: $0) }) {
            didFailLoad?(request, error)
        }
    }

    open func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        if let request = webView.url.map({ URLRequest(url: $0) }) {
            didFailLoad?(request, error)
        }
    }
}


#endif
