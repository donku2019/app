{include file='globalheader.tpl'}

<div id="page-login">
    {if $Announcements|default:array()|count > 0}
        <div id="announcements" class="col-sm-8 col-sm-offset-2 col-xs-12">
        {foreach from=$Announcements item=each}
            <div class="announcement">{$each->Text()|html_entity_decode|url2link|nl2br}</div>
        {/foreach}
        </div>
    {/if}

	<div class="offset-md-3 col-md-6 col-xs-12">
		{if $ShowLoginError}
			<!-- These alerts must goes here for a nice width (same as login form) -->
			<div id="loginError" class="alert alert-danger alert-dismissible fade show" role="alert">
				{translate key='LoginError'}
				<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
			</div>
		{/if}
    {if $EnableCaptcha}
        {validation_group class="alert alert-danger"}
        {validator id="captcha" key="CaptchaMustMatch"}
        {/validation_group}
    {/if}
		<form role="form" name="login" id="login" class="form-horizontal" method="post"
			  action="{$smarty.server.SCRIPT_NAME}">
			<div id="login-box" class="col-xs-12 p-5 shadow-sm border rounded">
				<div class="col-xs-12 center mb-3">
					{html_image src="$LogoUrl?{$Version}" alt="$Title"}
				</div>
				{if $ShowUsernamePrompt}
					<div class="col-xs-12">
						<div class="input-group mb-3">
							<span class="input-group-text"><i class="bi bi-person-fill"></i></span>
							<input type="text" required="" class="form-control"
								   id="email" {formname key=EMAIL}
								   placeholder="{translate key=UsernameOrEmail}"/>
						</div>
					</div>
				{/if}

				{if $ShowPasswordPrompt}
					<div class="col-xs-12">
						<div class="input-group mb-3">
							<span class="input-group-text"><i class="bi bi-lock-fill"></i></span>
							<input type="password" required="" id="password" {formname key=PASSWORD}
								   class="form-control"
								   value="" placeholder="{translate key=Password}"/>
						</div>
					</div>
				{/if}

                {if $EnableCaptcha}
                    <div class="col-xs-12">
                        <div class="mb-4">
                        {control type="CaptchaControl"}
                        </div>
                    </div>
                {else}
                    <input type="hidden" {formname key=CAPTCHA} value=""/>
                {/if}

				{if $ShowUsernamePrompt &&  $ShowPasswordPrompt}
				<div class="col-xs-12 center">
					<button type="submit" class="btn btn-sm btn-primary btn-block" name="{Actions::LOGIN}"
							value="submit">{translate key='LogIn'}</button>
					<input type="hidden" {formname key=RESUME} value="{$ResumeUrl}"/>
				</div>
				{/if}

				{if $ShowUsernamePrompt &&  $ShowPasswordPrompt}
				<div class="col-xs-12 {if $ShowRegisterLink}col-sm-6{/if}">
					<div class="checkbox">
						<input id="rememberMe" type="checkbox" {formname key=PERSIST_LOGIN}>
						<label for="rememberMe">{translate key=RememberMe}</label>
					</div>
				</div>
				{/if}

                {if $ShowRegisterLink}
                  <div class="d-grid gap-2 col-4 mx-auto mb-3">
                    <span class="bold">{translate key="FirstTimeUser?"}
                    <a href="{$RegisterUrl}" {if isset($RegisterUrlNew)}{$RegisterUrlNew}{/if}
                       title="{translate key=Register}">{translate key=Register}</a>
                    </span>
                  </div>
                {/if}

				<div class="clearfix"></div>

				{if $AllowGoogleLogin && $AllowFacebookLogin}
					{assign var=socialClass value="col-sm-12 col-md-6 text-start"}
				{else}
					{assign var=socialClass value="col-sm-12 text-start"}
				{/if}

				{if $AllowGoogleLogin}
					<div class="{$socialClass} social-login" id="socialLoginGoogle">
						<a href="https://accounts.google.com/o/oauth2/v2/auth?scope=email%20profile&state={$GoogleState}&redirect_uri=https://www.social.twinkletoessoftware.com/googleresume.php&response_type=code&client_id=531675809673-3sfvrchh6svd9bfl7m55dao8n4s6cqpc.apps.googleusercontent.com">
							<img src="img/external/btn_google_signin_dark_normal_web.png" alt="Sign in with Google"/>
						</a>
					</div>
				{/if}
				{if $AllowFacebookLogin}
					<div class="{$socialClass} social-login" id="socialLoginFacebook">
						<a href="https://www.social.twinkletoessoftware.com/fblogin.php?protocol={$Protocol}&resume={$ScriptUrlNoProtocol}/external-auth.php%3Ftype%3Dfb%26redirect%3D{$ResumeUrl}">
							<img style="max-height:42px" src="img/external/btn_facebook_login.png" alt="Sign in with Facebook"/>
						</a>
					</div>
				{/if}
			</div>
			<div id="login-footer" class="btn-toolbar justify-content-between">
				{if $ShowForgotPasswordPrompt}
					<div id="forgot-password" class="col-xs-12 col-sm-6">
						<a href="{$ForgotPasswordUrl}" {if isset($ForgotPasswordUrlNew)}{$ForgotPasswordUrlNew}{/if} class="btn btn-link float-start"><span><i class="bi bi-question-circle-fill"></i></span> {translate key='ForgotMyPassword'}</a>
					</div>
				{/if}
				<div class="col-xs-12 col-sm-6">
					<button type="button" class="btn btn-link float-end" data-bs-toggle="collapse"
							data-bs-target="#change-language-options"><span><i class="bi bi-globe"></i></span>
						{translate key=ChangeLanguage}
					</button>
					<div id="change-language-options" class="collapse">
						<select {formname key=LANGUAGE} class="form-control input-sm" id="languageDropDown">
							{object_html_options options=$Languages key='GetLanguageCode' label='GetDisplayName' selected=$SelectedLanguage}
						</select>
					</div>
				</div>
			</div>


		</form>
	</div>
</div>

{setfocus key='EMAIL'}

{include file="javascript-includes.tpl"}

<script type="text/javascript">
	var url = 'index.php?{QueryStringKeys::LANGUAGE}=';
	$(document).ready(function () {
		$('#languageDropDown').change(function () {
			window.location.href = url + $(this).val();
		});

		var langCode = readCookie('{CookieKeys::LANGUAGE}');

		if (!langCode)
		{
			langCode = (navigator.language+"").replace("-", "_").toLowerCase();

			var availableLanguages = [{foreach from=$Languages item=lang}"{$lang->GetLanguageCode()}",{/foreach}];
			if (langCode !== "" && langCode != '{$SelectedLanguage|lower}') {
				if (availableLanguages.indexOf(langCode) !== -1)
				{
					window.location.href = url + langCode;
				}
			}
		}
	});
</script>
{include file='globalfooter.tpl'}
