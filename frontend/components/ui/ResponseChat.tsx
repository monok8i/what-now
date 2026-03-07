import React, { useEffect, useState, useRef } from 'react';
import ReactMarkdown from 'react-markdown';
import { RefreshCcw, CheckCircle2, Info, AlertCircle, FileText, Send, Loader2, Bot, User, Map } from 'lucide-react';
import remarkGfm from 'remark-gfm';

export interface ApiResponse {
    message: string;
    submission_id?: string;
    total_matches?: number;
    matching_benefits?: any[];
    ai_response?: string;
}

interface ResponseChatProps {
    data: ApiResponse | null;
    isLoading?: boolean;
    onReset: () => void;
}

interface ChatMessage {
    id: string;
    role: 'user' | 'assistant';
    content: string;
    isError?: boolean;
}

export function ResponseChat({ data, isLoading = false, onReset }: ResponseChatProps) {
    const [messages, setMessages] = useState<ChatMessage[]>([]);
    const [inputValue, setInputValue] = useState('');
    const [isConnecting, setIsConnecting] = useState(false);
    const [isConnected, setIsConnected] = useState(false);
    const [isTyping, setIsTyping] = useState(false);
    const [loadingMsgIdx, setLoadingMsgIdx] = useState(0);

    const wsRef = useRef<WebSocket | null>(null);
    const messagesEndRef = useRef<HTMLDivElement>(null);

    const LOADING_MESSAGES = [
        "Analyzujeme vaši situaci...",
        "Počítáme vaše přesčasové hodiny nad péčí...",
        "Hledáme jehlu v kupce formulářů...",
        "Luštíme státní byrokracii a zákony...",
        "Zjišťujeme, na co všechno máte nárok...",
        "Ještě chvilinku, státní úřady mají polední pauzu...",
        "Zpracováváme všechny dostupné možnosti..."
    ];

    useEffect(() => {
        if (!isLoading) return;
        const interval = setInterval(() => {
            setLoadingMsgIdx(prev => (prev + 1) % LOADING_MESSAGES.length);
        }, 3000);
        return () => clearInterval(interval);
    }, [isLoading]);

    // connectWebSocket moved below

    const connectWebSocket = () => {
        setIsConnecting(true);
        let wsUrlStr = 'wss://tvuj-produkcni-zapisovy-endpoint.cz/ws/chat';
        if (typeof window !== 'undefined') {
            const hostname = window.location.hostname;
            if (hostname === 'localhost' || hostname === '127.0.0.1' || hostname === '0.0.0.0' || hostname.startsWith('192.168.')) {
                wsUrlStr = `ws://${hostname}:8001/ws/chat`;
            }
        }

        // If there's an env variable for API URL, parse it to build WS URL
        const envApiUrl = process.env.NEXT_PUBLIC_API_URL;
        if (envApiUrl) {
            try {
                const url = new URL(envApiUrl);
                wsUrlStr = `${url.protocol === 'https:' ? 'wss:' : 'ws:'}//${url.host}/ws/chat`;
            } catch (e) {
                console.error("Invalid NEXT_PUBLIC_API_URL", e);
            }
        }

        try {
            const ws = new WebSocket(wsUrlStr);

            ws.onopen = () => {
                setIsConnected(true);
                setIsConnecting(false);
            };

            ws.onmessage = (event) => {
                try {
                    const response = JSON.parse(event.data);

                    if (response.typing !== undefined) {
                        setIsTyping(response.typing);
                    }

                    if (response.message) {
                        setMessages(prev => [
                            ...prev,
                            {
                                id: Date.now().toString(),
                                role: 'assistant',
                                content: response.message,
                                isError: response.error || false
                            }
                        ]);
                        setIsTyping(false);
                    }
                } catch (e) {
                    console.error("Error parsing WS message:", e);
                }
            };

            ws.onclose = () => {
                setIsConnected(false);
                setIsConnecting(false);
                wsRef.current = null;
            };

            ws.onerror = (error) => {
                console.error("WebSocket error:", error);
                setIsConnecting(false);
            };

            wsRef.current = ws;
        } catch (error) {
            console.error("Failed to connect to WebSocket:", error);
            setIsConnecting(false);
        }
    };

    // Initialize chat
    useEffect(() => {
        if (data?.ai_response) {
            setMessages([
                {
                    id: 'initial',
                    role: 'assistant',
                    content: data.ai_response,
                }
            ]);
        } else {
            setMessages([]);
        }

        // Connect WebSocket on mount
        if (!wsRef.current) {
            connectWebSocket();
        }

        return () => {
            if (wsRef.current) {
                wsRef.current.close();
                wsRef.current = null;
            }
        };
    }, [data]);

    const scrollToBottom = () => {
        messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
    };

    useEffect(() => {
        scrollToBottom();
    }, [messages, isTyping]);

    const handleSendMessage = (e: React.FormEvent) => {
        e.preventDefault();

        if (!inputValue.trim()) return;

        const newMessage: ChatMessage = {
            id: Date.now().toString(),
            role: 'user',
            content: inputValue.trim(),
        };

        setMessages(prev => [...prev, newMessage]);
        setInputValue('');

        // Send via WebSocket
        if (wsRef.current && wsRef.current.readyState === WebSocket.OPEN) {
            setIsTyping(true);
            wsRef.current.send(JSON.stringify({ message: newMessage.content }));
        } else {
            // Try to reconnect and send
            connectWebSocket();
            setTimeout(() => {
                if (wsRef.current && wsRef.current.readyState === WebSocket.OPEN) {
                    setIsTyping(true);
                    wsRef.current.send(JSON.stringify({ message: newMessage.content }));
                } else {
                    setMessages(prev => [
                        ...prev,
                        {
                            id: Date.now().toString() + '-err',
                            role: 'assistant',
                            content: 'Omlouváme se, připojení k serveru selhalo. Zkuste to prosím znovu za chvíli.',
                            isError: true
                        }
                    ]);
                }
            }, 1000);
        }
    };

    if (!data && !isLoading) return null;

    const hasMatches = data ? (data.total_matches ?? 0) > 0 : false;

    return (
        <div className="bg-white rounded-3xl shadow-sm border border-slate-200/60 w-full flex flex-col overflow-hidden min-h-[600px] h-[calc(100vh-160px)]">
            {/* Header */}
            <div className="flex items-center justify-between px-6 py-4 border-b border-slate-100 bg-slate-50/80 backdrop-blur-md z-10 shrink-0">
                <div className="flex items-center gap-4">
                    <div className={`p-2.5 rounded-2xl ${hasMatches ? 'bg-green-100 text-green-600' : 'bg-indigo-100 text-indigo-600'}`}>
                        {isLoading ? <Loader2 className="w-6 h-6 animate-spin" /> : (hasMatches ? <CheckCircle2 className="w-6 h-6" /> : <Info className="w-6 h-6" />)}
                    </div>
                    <div>
                        <h2 className="text-xl font-bold text-slate-900">Vyhodnocení a Chat</h2>
                        <div className="flex items-center gap-2">
                            <p className="text-sm font-medium text-slate-500">{isLoading ? 'Zpracováváme vaše údaje...' : (data?.message || 'Zde jsou informace k vaší situaci.')}</p>
                            {!isLoading && (
                                <span className="flex items-center gap-1.5 text-xs font-medium px-2 py-0.5 rounded-full bg-slate-100 text-slate-500">
                                    <span className={`w-1.5 h-1.5 rounded-full ${isConnected ? 'bg-green-500' : 'bg-slate-300'}`}></span>
                                    {isConnected ? 'Připojeno' : 'Odpojeno'}
                                </span>
                            )}
                        </div>
                    </div>
                </div>
                <button
                    onClick={onReset}
                    className="p-2 text-slate-400 hover:text-slate-700 hover:bg-slate-200/60 rounded-full transition-colors flex items-center justify-center focus:outline-none focus:ring-2 focus:ring-slate-300"
                    title="Začít znovu / Vyplnit znovu formulář"
                    aria-label="Začít znovu"
                >
                    <RefreshCcw className="w-5 h-5" />
                </button>
            </div>

            {/* Content - Chat Messages */}
            <div className="flex-1 overflow-y-auto w-full bg-slate-50/50 p-6 md:p-8 space-y-6">
                {isLoading ? (
                    <div className="flex-1 w-full h-full flex flex-col justify-center items-center text-center space-y-8 animate-in fade-in duration-500 py-10">
                        <div className="relative flex justify-center items-center h-28 w-28 mb-4">
                            <div className="absolute inset-x-0 inset-y-0 rounded-full bg-indigo-100 animate-ping opacity-25"></div>
                            <div className="relative flex justify-center items-center h-20 w-20 bg-indigo-50 rounded-full border border-indigo-100 shadow-sm">
                                <Bot className="w-10 h-10 text-indigo-600 animate-pulse" />
                            </div>
                        </div>

                        <div className="h-10 px-4">
                            <h3 className="text-xl md:text-2xl font-medium text-slate-800 animate-pulse transition-all duration-300" key={loadingMsgIdx}>
                                {LOADING_MESSAGES[loadingMsgIdx]}
                            </h3>
                        </div>

                        {/* Skelet pro zprávy */}
                        <div className="w-full max-w-2xl space-y-6 mt-12 opacity-50 px-4">
                            <div className="flex gap-4">
                                <div className="w-10 h-10 rounded-full bg-slate-200 animate-pulse shrink-0"></div>
                                <div className="bg-slate-200 h-24 w-3/4 rounded-2xl rounded-tl-sm animate-pulse"></div>
                            </div>
                            <div className="flex gap-4 flex-row-reverse">
                                <div className="w-10 h-10 rounded-full bg-indigo-100 animate-pulse shrink-0"></div>
                                <div className="bg-indigo-100 h-16 w-1/2 rounded-2xl rounded-tr-sm animate-pulse"></div>
                            </div>
                            <div className="flex gap-4">
                                <div className="w-10 h-10 rounded-full bg-slate-200 animate-pulse shrink-0"></div>
                                <div className="space-y-3 w-3/4">
                                    <div className="bg-slate-200 h-8 w-full rounded-lg animate-pulse"></div>
                                    <div className="bg-slate-200 h-8 w-5/6 rounded-lg animate-pulse"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                ) : (
                    <>
                        {/* Welcome message with additional structured data if any */}
                        {hasMatches && data?.matching_benefits && data.matching_benefits.length > 0 && (
                            <div className="bg-white rounded-2xl p-5 border border-slate-100 shadow-sm mb-6">
                                <h3 className="text-base font-bold text-slate-900 mb-3 flex items-center gap-2">
                                    <CheckCircle2 className="w-5 h-5 text-green-500" />
                                    Nalezené konkrétní dávky
                                </h3>
                                <div className="grid gap-3 sm:grid-cols-2">
                                    {data.matching_benefits.map((benefit, idx) => (
                                        <div key={idx} className="bg-slate-50 rounded-xl p-3 border border-slate-100 flex items-start gap-3">
                                            <div className="w-1.5 h-1.5 rounded-full bg-indigo-500 mt-2 shrink-0" />
                                            <div>
                                                <p className="font-semibold text-slate-900 text-sm">{typeof benefit === 'string' ? benefit : benefit.name || 'Dávka'}</p>
                                                {benefit.description && <p className="text-xs text-slate-500 mt-1 line-clamp-2">{benefit.description}</p>}
                                            </div>
                                        </div>
                                    ))}
                                </div>
                            </div>
                        )}

                        {messages.length === 0 && !hasMatches && !data?.ai_response ? (
                            <div className="text-center py-12">
                                <FileText className="w-12 h-12 text-slate-300 mx-auto mb-4" />
                                <h3 className="text-lg font-medium text-slate-900">Žádná podrobnější analýza</h3>
                                <p className="text-slate-500 mt-2">Můžete se zeptat na další detaily pomocí chatu níže.</p>
                            </div>
                        ) : (
                            messages.map((msg, idx) => (
                                <div key={msg.id || idx} className={`flex items-start gap-4 ${msg.role === 'user' ? 'flex-row-reverse' : ''}`}>
                                    <div className={`w-10 h-10 rounded-full flex items-center justify-center shrink-0 ${msg.role === 'user' ? 'bg-indigo-600 text-white' : 'bg-slate-200 text-slate-600'}`}>
                                        {msg.role === 'user' ? <User className="w-5 h-5" /> : <Bot className="w-5 h-5" />}
                                    </div>
                                    <div className={`max-w-[85%] rounded-2xl p-5 ${msg.role === 'user' ? 'bg-indigo-600 text-white rounded-tr-sm' : msg.isError ? 'bg-red-50 border border-red-100 text-red-700 rounded-tl-sm' : 'bg-white border border-slate-100 shadow-sm rounded-tl-sm'}`}>
                                        {msg.role === 'user' ? (
                                            <p className="whitespace-pre-wrap">{msg.content}</p>
                                        ) : (
                                            <div className="prose prose-sm md:prose-base prose-slate max-w-none prose-p:leading-relaxed prose-a:text-indigo-600 hover:prose-a:underline prose-strong:text-slate-900">
                                                <ReactMarkdown
                                                    remarkPlugins={[remarkGfm]}
                                                    components={{
                                                        a: ({ ...props }) => {
                                                            // Map toggle button
                                                            if (props.href === '#map') {
                                                                return (
                                                                    <div className="mt-4 mb-2 flex justify-start not-prose">
                                                                        <button
                                                                            onClick={(e) => {
                                                                                e.preventDefault();
                                                                                alert("Zde se na tvé větvi rozbalí komponenta Map.tsx!");
                                                                                // TODO: Implement actual map toggle state
                                                                            }}
                                                                            className="inline-flex items-center gap-2 px-4 py-2 bg-slate-100 hover:bg-slate-200 text-slate-800 rounded-xl font-medium transition-colors border border-slate-200"
                                                                        >
                                                                            <Map className="w-4 h-4 text-indigo-500" />
                                                                            {props.children || "Zobrazit na mapě"}
                                                                        </button>
                                                                    </div>
                                                                );
                                                            }

                                                            // If the link text is exactly "ℹ️" and it points to "#info"
                                                            if (props.href === '#info' && typeof props.children === 'string' && props.children.includes('ℹ️')) {
                                                                const tooltipText = props.title || "Dodatečné informace";
                                                                return (
                                                                    <span className="relative inline-block group ml-1 cursor-help align-middle not-prose">
                                                                        <Info className="w-4 h-4 text-indigo-500 hover:text-indigo-700 inline" />
                                                                        <span className="absolute bottom-full left-1/2 -translate-x-1/2 mb-2 w-max max-w-xs p-2 bg-slate-800 text-white text-xs rounded-lg opacity-0 invisible group-hover:opacity-100 group-hover:visible transition-all duration-200 z-50 text-center shadow-lg pointer-events-none">
                                                                            {tooltipText}
                                                                            {/* Base arrow */}
                                                                            <span className="absolute top-full left-1/2 -translate-x-1/2 border-4 border-transparent border-t-slate-800"></span>
                                                                        </span>
                                                                    </span>
                                                                );
                                                            }
                                                            // Default rendering for other links
                                                            return <a {...props} target="_blank" rel="noopener noreferrer">{props.children}</a>;
                                                        }
                                                    }}
                                                >
                                                    {msg.content}
                                                </ReactMarkdown>
                                            </div>
                                        )}
                                    </div>
                                </div>
                            ))
                        )}

                        {isTyping && (
                            <div className="flex items-start gap-4">
                                <div className="w-10 h-10 rounded-full bg-slate-200 text-slate-600 flex items-center justify-center shrink-0">
                                    <Bot className="w-5 h-5" />
                                </div>
                                <div className="bg-white border border-slate-100 shadow-sm rounded-2xl rounded-tl-sm p-5 flex items-center gap-2">
                                    <span className="w-2 h-2 rounded-full bg-slate-300 animate-bounce" style={{ animationDelay: '0ms' }}></span>
                                    <span className="w-2 h-2 rounded-full bg-slate-300 animate-bounce" style={{ animationDelay: '150ms' }}></span>
                                    <span className="w-2 h-2 rounded-full bg-slate-300 animate-bounce" style={{ animationDelay: '300ms' }}></span>
                                </div>
                            </div>
                        )}

                        <div ref={messagesEndRef} />
                    </>
                )}
            </div>

            {/* Footer - Chat Input */}
            <div className="p-4 sm:p-6 border-t border-slate-100 bg-white z-10 shrink-0">
                <form onSubmit={handleSendMessage} className="relative flex items-end gap-2 max-w-5xl mx-auto w-full">
                    <textarea
                        value={inputValue}
                        onChange={(e) => setInputValue(e.target.value)}
                        onKeyDown={(e) => {
                            if (e.key === 'Enter' && !e.shiftKey) {
                                e.preventDefault();
                                handleSendMessage(e);
                            }
                        }}
                        placeholder="Napište doplňující zprávu pro chat..."
                        className="w-full bg-slate-50 border border-slate-200 text-slate-900 rounded-2xl px-5 py-4 pr-14 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-transparent resize-none overflow-hidden max-h-32 min-h-[56px]"
                        rows={1}
                        style={{
                            height: 'auto',
                            fieldSizing: 'content'
                        } as React.CSSProperties}
                    />
                    <button
                        type="submit"
                        disabled={!inputValue.trim()}
                        className={`absolute right-2 bottom-2 p-2.5 rounded-xl flex items-center justify-center transition-all ${inputValue.trim()
                            ? 'bg-indigo-600 text-white hover:bg-indigo-700 shadow-md shadow-indigo-100'
                            : 'bg-slate-100 text-slate-400 cursor-not-allowed'
                            }`}
                    >
                        <Send className="w-5 h-5" />
                    </button>
                </form>
            </div>
        </div>
    );
}
