/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package gjk4all.dictu.astest.tools;

import java.util.logging.Level;
import java.util.logging.Logger;
import javax.naming.Binding;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingEnumeration;
import javax.naming.NamingException;

/**
 *
 * @author gjk
 */
public class JndiWalker {
    private final Context ctx;
    private StringBuilder str;
    
    static public String PrintHtml(String ctxRoot) {
        try {
            JndiWalker j2l = new JndiWalker(ctxRoot);
            return j2l.printHtmlIntern();
        } catch (NamingException ex) {
            Logger.getLogger(JndiWalker.class.getName()).log(Level.SEVERE, null, ex);
            return "";
        }
    }

    private JndiWalker(String ctxRoot) throws NamingException {
        ctx = (Context)new InitialContext().lookup(ctxRoot);
        str = new StringBuilder();
    }

    public String printHtmlIntern() {
        listContext(ctx, str);
        return str.toString();
    }
    
    private void listContext(Context ctx, StringBuilder str) {
        try {
            NamingEnumeration list = ctx.listBindings("");
            str.append("[");
            while (list.hasMore()) {
                Binding item = (Binding) list.next();
                str.append("{name: '").append(item.getName()).append("'");
                Object o = item.getObject();
                if (o instanceof javax.naming.Context) {
                    str.append(",children: ");
                    listContext((Context) o, str);
                }
                str.append("}");
                if (list.hasMore()) {
                    str.append(",");
                }
            }
            str.append("]");
        } catch (NamingException ex) {
            Logger.getLogger(JndiWalker.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}
