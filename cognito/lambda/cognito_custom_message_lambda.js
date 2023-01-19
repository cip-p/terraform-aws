const fs = require('fs');

const SIGN_UP_EMAIL = fs.readFileSync('templates/signup-code.html', 'utf8');
const SIGN_UP_RESEND_EMAIL = fs.readFileSync('templates/signup-resend-code.html', 'utf8');
const FORGOT_PASSWORD_EMAIL = fs.readFileSync('templates/reset-password-code.html', 'utf8');

module.exports.handler = async (event, context, callback) => {
    if (event.triggerSource === "CustomMessage_SignUp") {
        event.response.emailSubject = "Your verification code";
        event.response.emailMessage = SIGN_UP_EMAIL.replace("{verification_code}", event.request.codeParameter);
    } else if (event.triggerSource === "CustomMessage_ForgotPassword") {
        event.response.emailSubject = "Your password reset code";
        event.response.emailMessage = FORGOT_PASSWORD_EMAIL.replace("{verification_code}", event.request.codeParameter);
    } else if (event.triggerSource === "CustomMessage_ResendCode") {
        event.response.emailSubject = "Your new verification code";
        event.response.emailMessage = SIGN_UP_RESEND_EMAIL.replace("{verification_code}", event.request.codeParameter);
    }

    // Return to Amazon Cognito
    callback(null, event);
};
